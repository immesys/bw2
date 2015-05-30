package oob

import (
	"bufio"
	"encoding/base64"
	"fmt"
	"math/rand"
	"net"
	"os"
	"strconv"
	"sync"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/store"
	"github.com/immesys/bw2/internal/util"
	"github.com/immesys/bw2/objects"
)

type Adapter struct {
	bw        *api.BW
	cachelock sync.RWMutex
	DNSCache  map[string]string
}

func (a *Adapter) Start(bw *api.BW) {
	fmt.Println("oob starting")
	a.bw = bw
	if len(bw.Config.OOB.ListenOn) == 0 {
		log.Warnf("No specified OOB listening port, listening on 127.0.0.1:28589")
	}
	ln, err := net.Listen("tcp", bw.Config.OOB.ListenOn)
	if err != nil {
		log.Errorf("Could not listen on '%s' for OOBAdapter: %v\n",
			bw.Config.OOB.ListenOn, err)
		log.Flush()
		os.Exit(1)
	}
	log.Infof("OOB listening on %s", bw.Config.OOB.ListenOn)
	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Warnf("OOB socket error: %v", err)
		}
		go a.handleClient(conn)
	}
}

//Sequence numbers are 31 bit positive integers
func mkSeqNo() int {
	return int(rand.Uint32() >> 1)
}

func (a *Adapter) handleClient(conn net.Conn) {
	bwcl := a.bw.CreateClient()
	out := bufio.NewWriter(conn)
	in := bufio.NewReader(conn)
	olock := sync.Mutex{}
	abort := false
	send := func(f *objects.Frame) {
		if abort {
			return
		}
		olock.Lock()
		f.WriteToStream(out)
		olock.Unlock()
	}

	helo := objects.CreateFrame(objects.CmdHello, mkSeqNo())
	helo.AddHeader("version", api.BW2Version)
	send(helo)

	for {
		f, err := objects.LoadFrameFromStream(in)
		if err != nil {
			log.Info("OOB stream error:", err)
			abort = true
			return
		}
		dispatchFrame(bwcl, f, send)
	}
}

func loadCommonURI(f *objects.Frame) ([]byte, string, bool) {
	mvk, mvkOk := f.GetFirstHeader("mvk")
	var rmvk []byte
	uri, uriOk := f.GetFirstHeader("uri")
	suffix, suffixOk := f.GetFirstHeader("uri_suffix")
	if uriOk {
		var ok bool
		rmvk, suffix, ok = api.SplitURI(uri)
		if !ok {
			return nil, "", false
		}
	} else if !(mvkOk && suffixOk) {
		return nil, "", false
	} else {
		if len(mvk) == 44 {
			rv, err := base64.URLEncoding.DecodeString(mvk)
			if err != nil {
				return nil, "", false
			}
			rmvk = rv
		} else if len(mvk) != 32 {
			return nil, "", false
		}
		valid, _, _, _, _ := util.AnalyzeSuffix(suffix)
		if !valid {
			return nil, "", false
		}
	}
	return rmvk, suffix, true
}
func loadCommonPAC(f *objects.Frame) (*objects.DChain, bool, string) {
	pac, pacok := f.GetFirstHeader("primary_access_chain")
	if !pacok {
		return nil, true, "" //No error, but no object
	}
	if len(pac) != 44 {
		return nil, false, "invalid PAC hash"
	}
	realhash, err := crypto.UnFmtHash(pac)
	if err != nil {
		return nil, false, "invalid PAC hash"
	}
	realpac, ok := store.GetDChain(realhash)
	if !ok {
		return nil, false, "could not resolve PAC"
	}
	return realpac, true, ""
}
func loadCommonExpiry(f *objects.Frame) (*time.Duration, *time.Time, bool, string) {
	expd, ok := f.GetFirstHeader("expirydelta")
	var rvd *time.Duration
	var rvt *time.Time
	if ok {
		dur, e := time.ParseDuration(expd)
		if e != nil {
			return nil, nil, false, "malformed expiry duration"
		}
		rvd = &dur
	}
	exp, ok := f.GetFirstHeader("expiry")
	if ok {
		t, e := time.Parse(time.RFC3339, exp)
		if e != nil {
			return nil, nil, false, "malformed expiry time"
		}
		rvt = &t
	}
	return rvd, rvt, true, ""
}
func loadCommonElaborate(f *objects.Frame) (int, bool) {
	elaboratePAC, ok := f.GetFirstHeader("elaborate_pac")
	if ok {
		switch elaboratePAC {
		case "partial":
			return api.PartialElaboration, true
		case "full":
			return api.FullElaboration, true
		default:
			return -1, false
		}
	}
	return api.NoElaboration, true
}
func loadCommonXOs(f *objects.Frame) ([]objects.RoutingObject, []objects.PayloadObject) {
	ros := make([]objects.RoutingObject, len(f.ROs))
	pos := make([]objects.PayloadObject, len(f.POs))
	//Add ROs
	for i, ro := range f.ROs {
		ros[i] = ro.RO
	}
	//Add POs
	for i, po := range f.POs {
		pos[i] = po.PO
	}
	return ros, pos
}
func commonUnpackMsg(m *core.Message, r *objects.Frame) {
	if m.OriginVK == nil {
		panic("Why no origin VK")
	}
	r.AddHeader("from", crypto.FmtKey(*m.OriginVK))
	r.AddHeader("uri", crypto.FmtKey(m.MVK)+"/"+m.TopicSuffix)
	for _, ro := range m.RoutingObjects {
		r.AddRoutingObject(ro)
	}
	for _, po := range m.PayloadObjects {
		r.AddPayloadObject(po)
	}
}
func commonUnpackEntity(e *objects.Entity, r *objects.Frame) {
	//TODO
}
func mkGenericActionCB(replyto int, send func(f *objects.Frame)) func(status int, msg string) {
	return func(status int, msg string) {
		if status == core.BWStatusOkay {
			r := objects.CreateFrame(objects.CmdResponse, replyto)
			r.AddHeader("status", "okay")
			send(r)
		} else {
			r := objects.CreateFrame(objects.CmdResponse, replyto)
			r.AddHeader("status", "error")
			r.AddHeader("reason", msg)
			r.AddHeader("code", strconv.Itoa(status))
			send(r)
		}
	}
}
func dispatchFrame(bwcl *api.BosswaveClient, f *objects.Frame, send func(f *objects.Frame)) {
	replyto := f.SeqNo
	err := func(msg string) {
		r := objects.CreateFrame(objects.CmdResponse, replyto)
		r.AddHeader("status", "error")
		r.AddHeader("reason", msg)
		send(r)
	}
	switch f.Cmd {
	case objects.CmdPublish, objects.CmdPersist:
		mvk, suffix, ok := loadCommonURI(f)
		if !ok {
			err("malformed URI components")
			return
		}
		pac, ok, msg := loadCommonPAC(f)
		if !ok {
			err(msg)
			return
		}
		expd, expt, ok, msg := loadCommonExpiry(f)
		if !ok {
			err(msg)
			return
		}
		el, ok := loadCommonElaborate(f)
		if !ok {
			err("malformed PAC elaboration directive")
			return
		}
		sverify, ok := f.GetFirstHeader("doverify")
		verify := false
		if ok {
			cx, e := strconv.ParseBool(sverify)
			if e != nil {
				err("malformed doverify")
				return
			}
			verify = cx
		}
		ros, pos := loadCommonXOs(f)
		p := &api.PublishParams{
			MVK:                mvk,
			URISuffix:          suffix,
			PrimaryAccessChain: pac,
			ExpiryDelta:        expd,
			Expiry:             expt,
			ElaboratePAC:       el,
			RoutingObjects:     ros,
			PayloadObjects:     pos,
			Persist:            f.Cmd == objects.CmdPersist,
			DoVerify:           verify,
		}
		bwcl.Publish(p, mkGenericActionCB(replyto, send))
		return
	case objects.CmdList:
		mvk, suffix, ok := loadCommonURI(f)
		if !ok {
			err("malformed URI components")
			return
		}
		pac, ok, msg := loadCommonPAC(f)
		if !ok {
			err(msg)
			return
		}
		el, ok := loadCommonElaborate(f)
		if !ok {
			err("malformed PAC elaboration directive")
			return
		}
		expd, expt, ok, msg := loadCommonExpiry(f)
		if !ok {
			err(msg)
			return
		}
		ros, _ := loadCommonXOs(f)
		p := &api.ListParams{
			MVK:                mvk,
			URISuffix:          suffix,
			PrimaryAccessChain: pac,
			ExpiryDelta:        expd,
			Expiry:             expt,
			ElaboratePAC:       el,
			RoutingObjects:     ros,
		}
		bwcl.List(p,
			mkGenericActionCB(replyto, send),
			func(s string, ok bool) {
				r := objects.CreateFrame(objects.CmdResult, replyto)
				r.AddHeader("finished", strconv.FormatBool(!ok))
				if ok {
					r.AddHeader("child", s)
				}
				send(r)
			})
	case objects.CmdQuery:
		runpack, ok := f.GetFirstHeader("unpack")
		unpack := false
		if ok {
			cx, e := strconv.ParseBool(runpack)
			if e != nil {
				err("Malformed unpack kn")
				return
			}
			unpack = cx
		}
		mvk, suffix, ok := loadCommonURI(f)
		if !ok {
			err("malformed URI components")
			return
		}
		pac, ok, msg := loadCommonPAC(f)
		if !ok {
			err(msg)
			return
		}
		el, ok := loadCommonElaborate(f)
		if !ok {
			err("malformed PAC elaboration directive")
			return
		}
		expd, expt, ok, msg := loadCommonExpiry(f)
		if !ok {
			err(msg)
			return
		}
		ros, _ := loadCommonXOs(f)
		p := &api.QueryParams{
			MVK:                mvk,
			URISuffix:          suffix,
			PrimaryAccessChain: pac,
			ExpiryDelta:        expd,
			Expiry:             expt,
			ElaboratePAC:       el,
			RoutingObjects:     ros,
		}
		bwcl.Query(p,
			mkGenericActionCB(replyto, send),
			func(m *core.Message) {
				r := objects.CreateFrame(objects.CmdResult, replyto)
				r.AddHeader("finished", strconv.FormatBool(m == nil))
				if m != nil {
					if unpack {
						commonUnpackMsg(m, r)
					} else {
						po, err := objects.CreateOpaquePayloadObjectDF("1.0.1.1", m.Encoded)
						if err != nil {
							panic("Not expecting this")
						}
						r.AddPayloadObject(po)
					}
				}
				send(r)
			})
	case objects.CmdSubscribe:
		runpack, ok := f.GetFirstHeader("unpack")
		unpack := false
		if ok {
			cx, e := strconv.ParseBool(runpack)
			if e != nil {
				err("Malformed unpack kn")
				return
			}
			unpack = cx
		}
		mvk, suffix, ok := loadCommonURI(f)
		if !ok {
			err("malformed URI components")
			return
		}
		pac, ok, msg := loadCommonPAC(f)
		if !ok {
			err(msg)
			return
		}
		el, ok := loadCommonElaborate(f)
		if !ok {
			err("malformed PAC elaboration directive")
			return
		}
		expd, expt, ok, msg := loadCommonExpiry(f)
		if !ok {
			err(msg)
			return
		}
		ros, _ := loadCommonXOs(f)
		p := &api.SubscribeParams{
			MVK:                mvk,
			URISuffix:          suffix,
			PrimaryAccessChain: pac,
			ExpiryDelta:        expd,
			Expiry:             expt,
			ElaboratePAC:       el,
			RoutingObjects:     ros,
		}
		bwcl.Subscribe(p,
			func(status int, isNew bool, id core.UniqueMessageID, msg string) {
				if status == core.BWStatusOkay {
					r := objects.CreateFrame(objects.CmdResponse, replyto)
					r.AddHeader("status", "okay")
					r.AddHeader("duplicate", strconv.FormatBool(!isNew))
					r.AddHeader("handle", id.ToString())
					send(r)
				} else {
					r := objects.CreateFrame(objects.CmdResponse, replyto)
					r.AddHeader("status", "error")
					r.AddHeader("reason", msg)
					r.AddHeader("code", strconv.Itoa(status))
					send(r)
				}
			},
			func(m *core.Message) {
				r := objects.CreateFrame(objects.CmdResult, replyto)
				if unpack {
					commonUnpackMsg(m, r)
				} else {
					po, err := objects.CreateOpaquePayloadObjectDF("1.0.1.1", m.Encoded)
					if err != nil {
						panic("Not expecting this")
					}
					r.AddPayloadObject(po)
				}
				send(r)
			})
	case objects.CmdMakeEntity:
		expd, expt, ok, msg := loadCommonExpiry(f)
		if !ok {
			err(msg)
			return
		}
		contact, _ := f.GetFirstHeader("contact")
		comment, _ := f.GetFirstHeader("comment")
		var revokers [][]byte
		for _, rhash := range f.GetAllHeaders("revoker") {
			rvk, e := crypto.UnFmtHash(rhash)
			if e != nil {
				err("invalid revoker kv")
				return
			}
			revokers = append(revokers, rvk)
		}
		romit, ok := f.GetFirstHeader("omitcreationdate")
		omit := false
		if ok {
			cx, e := strconv.ParseBool(romit)
			if e != nil {
				err("invalid omitcreationdate")
				return
			}
			omit = cx
		}
		p := &api.CreateEntityParams{
			Expiry:           expt,
			ExpiryDelta:      expd,
			Contact:          contact,
			Comment:          comment,
			Revokers:         revokers,
			OmitCreationDate: omit,
		}
		ent := bwcl.CreateEntity(p)
		if ent == nil {
			err("failed to create entity")
			return
		}
		r := objects.CreateFrame(objects.CmdResult, replyto)
		r.AddHeader("vk", crypto.FmtKey(ent.GetVK()))
		po, err := objects.CreateOpaquePayloadObjectDF("1.0.1.2", ent.GetSigningBlob())
		if err != nil {
			panic("Not expecting this")
		}
		r.AddPayloadObject(po)
		send(r)

	case objects.CmdMakeDot:
		sttl, ok := f.GetFirstHeader("ttl")
		ttl := 0
		if ok {
			cx, e := strconv.ParseUint(sttl, 10, 8)
			if e != nil {
				err("could not parse TTL")
				return
			}
			ttl = int(cx)
		}
		sto, ok := f.GetFirstHeader("to")
		if !ok {
			err("create dot requires 'to' kv")
			return
		}
		to, e := crypto.UnFmtKey(sto)
		if e != nil {
			err("could not parse TO kv")
			return
		}
		ispermission := false
		sispermission, ok := f.GetFirstHeader("ispermission")
		if ok {
			cx, e := strconv.ParseBool(sispermission)
			if e != nil {
				err("could not parse 'ispermission' kv")
				return
			}
			ispermission = cx
		}
		expd, expt, ok, msg := loadCommonExpiry(f)
		if !ok {
			err(msg)
			return
		}
		contact, _ := f.GetFirstHeader("contact")
		comment, _ := f.GetFirstHeader("comment")
		var revokers [][]byte
		for _, rhash := range f.GetAllHeaders("revoker") {
			rvk, e := crypto.UnFmtHash(rhash)
			if e != nil {
				err("invalid revoker kv")
				return
			}
			revokers = append(revokers, rvk)
		}
		romit, ok := f.GetFirstHeader("omitcreationdate")
		omit := false
		if ok {
			cx, e := strconv.ParseBool(romit)
			if e != nil {
				err("invalid omitcreationdate")
				return
			}
			omit = cx
		}

		p := api.CreateDOTParams{
			IsPermission:     ispermission,
			To:               to,
			TTL:              uint8(ttl),
			Expiry:           expt,
			ExpiryDelta:      expd,
			Contact:          contact,
			Comment:          comment,
			Revokers:         revokers,
			OmitCreationDate: omit,
		}

		if !ispermission {
			mvk, suffix, ok := loadCommonURI(f)
			if !ok {
				err("access DOTs require URI")
				return
			}
			perms, ok := f.GetFirstHeader("accesspermissions")
			if !ok {
				err("access DOTs require a permission string")
				return
			}
			p.MVK = mvk
			p.URISuffix = suffix
			p.AccessPermissions = perms
		} else {
			//TODO application level permissions, probably as PO's
		}
		dot := bwcl.CreateDOT(&p)
		if dot == nil {
			err("failed to create DOT")
			return
		}
		r := objects.CreateFrame(objects.CmdResult, replyto)
		r.AddHeader("hash", crypto.FmtHash(dot.GetHash()))
		df := "0.0.0.32"
		if ispermission {
			df = "0.0.0.33"
		}
		po, err := objects.CreateOpaquePayloadObjectDF(df, dot.GetContent())
		if err != nil {
			panic("Not expecting this")
		}
		r.AddPayloadObject(po)
		send(r)
	case objects.CmdSetEntity:
		if len(f.POs) != 1 {
			err("expected one PO: the key")
			return
		}
		po := f.POs[0].PO
		//TODO don't hardcode shit
		if po.GetPONum() != 16777474 {
			err("expected PO type 1.0.1.2")
			return
		}
		status := bwcl.SetEntity(&api.SetEntityParams{Keyfile: po.GetContent()})
		if status == core.BWStatusOkay {
			r := objects.CreateFrame(objects.CmdResponse, replyto)
			r.AddHeader("status", "okay")
			send(r)
		} else {
			r := objects.CreateFrame(objects.CmdResponse, replyto)
			r.AddHeader("status", "error")
			r.AddHeader("reason", "see code("+strconv.Itoa(status)+")")
			r.AddHeader("code", strconv.Itoa(status))
			send(r)
		}
	case objects.CmdMakeChain:
		ispermission := false
		sispermission, ok := f.GetFirstHeader("ispermission")
		if ok {
			cx, e := strconv.ParseBool(sispermission)
			if e != nil {
				err("could not parse 'ispermission' kv")
				return
			}
			ispermission = cx
		}
		unelaborate := false
		sunelaborate, ok := f.GetFirstHeader("unelaborate")
		if ok {
			cx, e := strconv.ParseBool(sunelaborate)
			if e != nil {
				err("could not parse 'unelaborate' kv")
				return
			}
			unelaborate = cx
		}
		var DOTs []*objects.DOT
		for _, sdhash := range f.GetAllHeaders("dot") {
			dhash, e := crypto.UnFmtHash(sdhash)
			if e != nil {
				err("could not parse dot hash")
				return
			}
			rdot, ok := store.GetDOT(dhash)
			if !ok {
				err("Could not resolve dot hash")
				return
			}
			DOTs = append(DOTs, rdot)
		}
		p := api.CreateDotChainParams{
			DOTs:         DOTs,
			IsPermission: ispermission,
			UnElaborate:  unelaborate,
		}
		dchain := bwcl.CreateDOTChain(&p)
		if dchain == nil {
			err("could not create chain")
			return
		}
		r := objects.CreateFrame(objects.CmdResult, replyto)
		r.AddHeader("hash", crypto.FmtHash(dchain.GetChainHash()))
		var df string
		switch {
		case ispermission && unelaborate:
			df = "0.0.0.17"
		case ispermission && !unelaborate:
			df = "0.0.0.18"
		case !ispermission && unelaborate:
			df = "0.0.0.1"
		case !ispermission && !unelaborate:
			df = "0.0.0.2"
		}
		po, err := objects.CreateOpaquePayloadObjectDF(df, dchain.GetContent())
		if err != nil {
			panic("Not expecting this")
		}
		r.AddPayloadObject(po)
		send(r)

		/*
			case CmdPutDot:
			case CmdPutChain:
			case CmdPutEntity:
		*/
	default:
		err("invalid command")
		return
	}
}
