// This file is part of BOSSWAVE.
//
// BOSSWAVE is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// BOSSWAVE is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with BOSSWAVE.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright © 2015 Michael Andersen <m.andersen@cs.berkeley.edu>

package oob

import (
	"bufio"
	"math/rand"
	"net"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/bc"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util"
	"github.com/immesys/bw2/util/bwe"
)

type Adapter struct {
	bw *api.BW
}

func (a *Adapter) Start(bw *api.BW) {
	log.Infof("OOB starting")
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
	bwcl := a.bw.CreateClient("OOB:" + conn.RemoteAddr().String())
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
	helo.AddHeader("version", util.BW2Version)
	send(helo)

	defer func() {
		bwcl.Destroy()
	}()

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

func (bf *boundFrame) loadAccount() int {
	account, accountOK := bf.f.GetFirstHeader("account")
	if !accountOK {
		return 0
	}
	acci, err := strconv.ParseInt(account, 10, 64)
	if err != nil {
		panic(bwe.M(bwe.MalformedOOBCommand, "Invalid account number"))
	}
	if acci < 0 || acci >= bc.MaxEntityAccounts {
		panic(bwe.M(bwe.MalformedOOBCommand, "Invalid account number"))
	}
	return int(acci)
}

func (bf *boundFrame) loadCommonURI() ([]byte, string) {
	//XTAG new resolver
	mvk, mvkOk := bf.f.GetFirstHeader("mvk")
	var rmvk []byte
	uri, uriOk := bf.f.GetFirstHeader("uri")
	suffix, suffixOk := bf.f.GetFirstHeader("uri_suffix")
	if uriOk {
		var err error
		parts := strings.SplitN(uri, "/", 2)
		if len(parts) != 2 {
			panic(bwe.M(bwe.BadURI, "URI should be namespace/suffix"))
		}
		//XTAG new resolver
		rmvk, err = bf.bwcl.BW().ResolveKey(parts[0])
		if err != nil {
			panic(bwe.WrapM(bwe.ResolutionFailed, "Could not resolve namespace", err))
		}
		suffix = parts[1]
	} else if !(mvkOk && suffixOk) {
		panic(bwe.M(bwe.InvalidOOBCommand, "Both uri_suffix and mvk must be present"))
	} else {
		if len(mvk) == 44 {
			nsvk, err := crypto.UnFmtKey(mvk)
			if err != nil {
				panic(bwe.M(bwe.MalformedOOBCommand, "MVK is malformed"))
			}
			rmvk = nsvk
		}
		valid, _, _, _, _ := util.AnalyzeSuffix(suffix)
		if !valid {
			panic(bwe.M(bwe.MalformedOOBCommand, "Suffix is malformed"))
		}
	}
	return rmvk, suffix
}

type BuildChainParams struct {
	To          []byte
	URI         string
	Status      chan string
	Permissions string
	Peers       []string
}

func (bf *boundFrame) loadBoolParam(name string) bool {
	v, _, emsg := bf.f.ParseFirstHeaderAsBool(name, false)
	if emsg != nil {
		panic(bwe.M(bwe.MalformedOOBCommand, "bad "+name+" param:"+*emsg))
	}
	return v
}

//Panics on error, returns nil or object on success
func (bf *boundFrame) loadCommonPAC(autochain bool, perms string) *objects.DChain {
	if autochain {
		return nil
		//
		// if bf.bwcl.GetUs() == nil {
		// 	panic(bwe.C(bwe.NoEntity))
		// }
		// log.Info("autochaining")
		// mvk, suffix := bf.loadCommonURI()
		// //XTAG new chainbuilder
		// ch, err := bf.bwcl.BuildChain(&api.BuildChainParams{
		// 	To:          bf.bwcl.GetUs().GetVK(),
		// 	URI:         crypto.FmtKey(mvk) + "/" + suffix,
		// 	Status:      nil,
		// 	Permissions: perms,
		// })
		// if err != nil {
		// 	panic(bwe.AsBW(err))
		// }
		// log.Info("blocking on chain")
		// realpac := <-ch
		// log.Info("built")
		// if realpac == nil {
		// 	panic(bwe.C(bwe.ChainBuildFailed))
		// }
		// //XTAG: this is preeety ugly. We should create a reverse channel to stop
		// //XTAG: chain building. That would save a lot of cpu time too
		// go func() {
		// 	for _ = range ch {
		// 	}
		// }()
		// return realpac
	}
	pac, pacok := bf.f.GetFirstHeader("primary_access_chain")
	if !pacok {
		//This is ok, they just did not specify a PAC
		return nil
	}
	realhash, err := crypto.UnFmtHash(pac)
	if err != nil {
		panic(bwe.M(bwe.InvalidCoding, "invalid PAC hash"))
	}
	realpac, _, err := bf.bwcl.BW().ResolveAccessDChain(realhash)
	if err != nil {
		panic(err)
	}
	return realpac
}
func (bf *boundFrame) checkChainAge() {
	bf.checkHaveChain()
	if bf.bwcl.ChainStale() {
		panic(bwe.M(bwe.ChainStale, "Chain is too stale"))
	}
}
func (bf *boundFrame) checkHaveChain() {
	//TODO add this in

}
func (bf *boundFrame) loadCommonExpiry() (*time.Duration, *time.Time) {
	expd, ok := bf.f.GetFirstHeader("expirydelta")
	var rvd *time.Duration
	var rvt *time.Time
	if ok {
		dur, e := time.ParseDuration(expd)
		if e != nil {
			panic(bwe.M(bwe.MalformedOOBCommand, "malformed expiry duration"))
		}
		rvd = &dur
	}
	exp, ok := bf.f.GetFirstHeader("expiry")
	if ok {
		t, e := time.Parse(time.RFC3339, exp)
		if e != nil {
			panic(bwe.M(bwe.MalformedOOBCommand, "malformed expiry time"))
		}
		rvt = &t
	}
	return rvd, rvt
}
func (bf *boundFrame) loadCommonElaborate() int {
	elaboratePAC, ok := bf.f.GetFirstHeader("elaborate_pac")

	if ok {
		switch elaboratePAC {
		case "partial":
			return api.PartialElaboration
		case "full":
			return api.FullElaboration
		case "none":
			return api.NoElaboration
		default:
			panic(bwe.M(bwe.MalformedOOBCommand, "malformed elaborate_pac"))
		}
	}
	return api.PartialElaboration
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

func (bf *boundFrame) mkGenericActionCB() func(err error) {
	return func(err error) {
		if err == nil {
			r := objects.CreateFrame(objects.CmdResponse, bf.replyto)
			r.AddHeader("status", "okay")
			bf.send(r)
		} else {
			bws := bwe.AsBW(err)
			r := objects.CreateFrame(objects.CmdResponse, bf.replyto)
			r.AddHeader("status", "error")
			r.AddHeader("reason", bws.Msg)
			r.AddHeader("code", strconv.Itoa(bws.Code))
			bf.send(r)
		}
	}
}

func (bf *boundFrame) mkFinalGenericActionCB() func(err error) {
	return func(err error) {
		if err == nil {
			r := objects.CreateFrame(objects.CmdResponse, bf.replyto)
			r.AddHeader("status", "okay")
			r.AddHeader("finished", "true")
			bf.send(r)
		} else {
			bws := bwe.AsBW(err)
			r := objects.CreateFrame(objects.CmdResponse, bf.replyto)
			r.AddHeader("status", "error")
			r.AddHeader("finished", "true")
			r.AddHeader("reason", bws.Msg)
			r.AddHeader("code", strconv.Itoa(bws.Code))
			bf.send(r)
		}
	}
}

func (bf *boundFrame) mkNonfinalResponseOkayFrame() *objects.Frame {
	r := objects.CreateFrame(objects.CmdResponse, bf.replyto)
	r.AddHeader("status", "okay")
	r.AddHeader("finished", "false")
	return r
}

func (bf *boundFrame) mkFinalResponseOkayFrame() *objects.Frame {
	r := objects.CreateFrame(objects.CmdResponse, bf.replyto)
	r.AddHeader("status", "okay")
	r.AddHeader("finished", "true")
	return r
}

type boundFrame struct {
	bwcl    *api.BosswaveClient
	f       *objects.Frame
	send    func(f *objects.Frame)
	replyto int
}

func (bf *boundFrame) Err(err error) {
	bws := bwe.AsBW(err)

	r := objects.CreateFrame(objects.CmdResponse, bf.replyto)
	r.AddHeader("status", "error")
	r.AddHeader("reason", bws.Msg)
	r.AddHeader("code", strconv.Itoa(bws.Code))
	r.AddHeader("finished", "true")
	bf.send(r)
}
func (bf *boundFrame) loadEntityPoOrUs() *objects.Entity {
	var ent *objects.Entity
	if len(bf.f.POs) > 0 {
		po := bf.f.POs[0].PO
		if po.GetPONum() != objects.PONumROEntityWKey {
			panic(bwe.M(bwe.MalformedOOBCommand, "expected ROEntityWKey"))
		}
		enti, err := objects.NewEntity(objects.PONumROEntityWKey, po.GetContent())
		if err != nil {
			panic(bwe.WrapM(bwe.MalformedOOBCommand, "could not load entity", err))
		}
		ent = enti.(*objects.Entity)
	} else {
		ent = bf.bwcl.GetUs()
	}
	return ent
}
func (bf *boundFrame) Handle() {
	switch bf.f.Cmd {

	case objects.CmdPublish, objects.CmdPersist:
		bf.cmdPublishPersist()

	case objects.CmdList:
		bf.cmdList()

	case objects.CmdQuery:
		bf.cmdQuery()

	case objects.CmdSubscribe:
		bf.cmdSubscribe()

	case objects.CmdMakeEntity:
		bf.cmdMakeEntity()

	case objects.CmdMakeDot:
		bf.cmdMakeDot()

	case objects.CmdSetEntity:
		bf.cmdSetEntity()

	case objects.CmdMakeChain:
		bf.cmdMakeChain()

	case objects.CmdBuildChain:
		bf.cmdBuildChain()

	case objects.CmdPutDot:
		bf.cmdPutDot()
	case objects.CmdPutEntity:
		bf.cmdPutEntity()
	case objects.CmdPutChain:
		bf.cmdPutChain()
	case objects.CmdEntityBalances:
		bf.cmdEntityBalances()
	case objects.CmdAddressBalance:
		bf.cmdAddressBalance()
	case objects.CmdBCInteractionParams:
		bf.cmdBCInteractionParams()
	case objects.CmdTransfer:
		bf.cmdTransfer()
	case objects.CmdMakeShortAlias:
		bf.cmdMakeShortAlias()
	case objects.CmdMakeLongAlias:
		bf.cmdMakeLongAlias()
	case objects.CmdResolveAlias:
		bf.cmdResolveAlias()
	case objects.CmdNewDROffer:
		bf.cmdNewDesignatedRouterOffer()
	case objects.CmdAcceptDROffer:
		bf.cmdAcceptDesignatedRouterOffer()
	case objects.CmdResolveRegistryObject:
		bf.cmdResolveRegistryObject()
	case objects.CmdUpdateSRVRecord:
		bf.cmdUpdateSRVRecord()
	case objects.CmdListDROffers:
		bf.cmdListDesignatedRouterOffers()
	case objects.CmdMakeView:
		bf.cmdMakeView()
	case objects.CmdListView:
		bf.cmdListView()
	case objects.CmdPublishView:
		bf.cmdPubView()
	case objects.CmdSubscribeView:
		bf.cmdSubView()
	case objects.CmdUnsubscribe:
		bf.cmdUnsubscribe()
	case "devl":
		bf.cmdDevelop()
	default:
		bf.Err(bwe.M(bwe.InvalidOOBCommand, "Unknown OOB command "+bf.f.Cmd))
		return
	}
}

func dispatchFrame(bwcl *api.BosswaveClient, f *objects.Frame, send func(f *objects.Frame)) {

	bf := &boundFrame{
		bwcl:    bwcl,
		f:       f,
		send:    send,
		replyto: f.SeqNo,
	}
	defer func() {
		if r := recover(); r != nil {
			bf.Err(r.(error))
		}
	}()
	bf.Handle()
}
