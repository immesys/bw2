package oob

import (
	"fmt"
	"strconv"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util/bwe"
)

func (bf *boundFrame) cmdPublishPersist() {
	mvk, suffix := bf.loadCommonURI()
	autochain := bf.loadBoolParam("autochain")
	pac := bf.loadCommonPAC(autochain, "P")
	expd, expt := bf.loadCommonExpiry()
	el := bf.loadCommonElaborate()
	verify := bf.loadBoolParam("doverify")
	ros, pos := loadCommonXOs(bf.f)
	p := &api.PublishParams{
		MVK:                mvk,
		URISuffix:          suffix,
		PrimaryAccessChain: pac,
		ExpiryDelta:        expd,
		Expiry:             expt,
		ElaboratePAC:       el,
		RoutingObjects:     ros,
		PayloadObjects:     pos,
		Persist:            bf.f.Cmd == objects.CmdPersist,
		DoVerify:           verify,
		AutoChain:          autochain,
	}
	bf.bwcl.Publish(p, bf.mkFinalGenericActionCB())
}

func (bf *boundFrame) cmdList() {
	mvk, suffix := bf.loadCommonURI()
	autochain := bf.loadBoolParam("autochain")
	pac := bf.loadCommonPAC(autochain, "L")
	el := bf.loadCommonElaborate()
	expd, expt := bf.loadCommonExpiry()
	ros, _ := loadCommonXOs(bf.f)
	p := &api.ListParams{
		MVK:                mvk,
		URISuffix:          suffix,
		PrimaryAccessChain: pac,
		ExpiryDelta:        expd,
		Expiry:             expt,
		ElaboratePAC:       el,
		RoutingObjects:     ros,
		AutoChain:          autochain,
	}
	bf.bwcl.List(p,
		bf.mkGenericActionCB(),
		func(s string, ok bool) {
			r := objects.CreateFrame(objects.CmdResult, bf.replyto)
			r.AddHeader("finished", strconv.FormatBool(!ok))
			if ok {
				r.AddHeader("child", s)
			}
			bf.send(r)
		})
}
func (bf *boundFrame) cmdQuery() {
	unpack := bf.loadBoolParam("unpack")
	autochain := bf.loadBoolParam("autochain")
	mvk, suffix := bf.loadCommonURI()
	pac := bf.loadCommonPAC(autochain, "C")
	el := bf.loadCommonElaborate()
	expd, expt := bf.loadCommonExpiry()
	ros, _ := loadCommonXOs(bf.f)
	p := &api.QueryParams{
		MVK:                mvk,
		URISuffix:          suffix,
		PrimaryAccessChain: pac,
		ExpiryDelta:        expd,
		Expiry:             expt,
		ElaboratePAC:       el,
		RoutingObjects:     ros,
		AutoChain:          autochain,
	}
	bf.bwcl.Query(p,
		bf.mkGenericActionCB(),
		func(m *core.Message) {
			r := objects.CreateFrame(objects.CmdResult, bf.replyto)
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
			bf.send(r)
		})
}

//TODO fix the finished logic and stuff. When subscriptions end you should get
//a nil message and then send finished. If only a response appears you should
//send finished etc etc. The client should know that it will ALWAYS get a
//finished = true
func (bf *boundFrame) cmdSubscribe() {
	unpack := bf.loadBoolParam("unpack")
	autochain := bf.loadBoolParam("autochain")
	mvk, suffix := bf.loadCommonURI()
	pac := bf.loadCommonPAC(autochain, "C")
	el := bf.loadCommonElaborate()
	expd, expt := bf.loadCommonExpiry()
	ros, _ := loadCommonXOs(bf.f)
	p := &api.SubscribeParams{
		MVK:                mvk,
		URISuffix:          suffix,
		PrimaryAccessChain: pac,
		ExpiryDelta:        expd,
		Expiry:             expt,
		ElaboratePAC:       el,
		RoutingObjects:     ros,
		AutoChain:          autochain,
	}
	bf.bwcl.Subscribe(p,
		func(err error, id core.UniqueMessageID) {
			if err == nil {
				r := objects.CreateFrame(objects.CmdResponse, bf.replyto)
				r.AddHeader("status", "okay")
				r.AddHeader("handle", id.ToString())
				r.AddHeader("finished", "false")
				bf.send(r)
			} else {
				bf.Err(err)
			}
		},
		func(m *core.Message) {
			r := objects.CreateFrame(objects.CmdResult, bf.replyto)
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
			bf.send(r)
		})
}
func (bf *boundFrame) cmdMakeEntity() {
	expd, expt := bf.loadCommonExpiry()
	contact, _ := bf.f.GetFirstHeader("contact")
	comment, _ := bf.f.GetFirstHeader("comment")
	omit := bf.loadBoolParam("omitcreationdate")
	var revokers [][]byte
	for _, rhash := range bf.f.GetAllHeaders("revoker") {
		rvk, e := crypto.UnFmtHash(rhash)
		if e != nil {
			panic(bwe.M(bwe.MalformedOOBCommand, "invalid revoker hash"))
		}
		revokers = append(revokers, rvk)
	}

	p := &api.CreateEntityParams{
		Expiry:           expt,
		ExpiryDelta:      expd,
		Contact:          contact,
		Comment:          comment,
		Revokers:         revokers,
		OmitCreationDate: omit,
	}
	ent, err := api.CreateEntity(p)
	if err != nil {
		panic(err)
	}
	r := bf.mkFinalResponseOkayFrame()
	r.AddHeader("vk", crypto.FmtKey(ent.GetVK()))
	po, err := objects.CreateOpaquePayloadObject(objects.ROEntityWKey, ent.GetSigningBlob())
	if err != nil {
		panic(err)
	}
	r.AddPayloadObject(po)
	bf.send(r)
}

func (bf *boundFrame) cmdMakeDot() {
	ttl, _, emsg := bf.f.ParseFirstHeaderAsInt("ttl", 0)
	if emsg != nil {
		panic(bwe.M(bwe.MalformedOOBCommand, "bad ttl param:"+*emsg))
	}
	if ttl < 0 || ttl > 255 {
		panic(bwe.M(bwe.MalformedOOBCommand, "ttl out of rane"))
	}
	sto, ok := bf.f.GetFirstHeader("to")
	if !ok {
		panic(bwe.M(bwe.MalformedOOBCommand, "missing 'to' kv"))
	}
	to, e := crypto.UnFmtKey(sto)
	if e != nil {
		panic(bwe.M(bwe.MalformedOOBCommand, "bad 'to' kv"))
	}
	ispermission := bf.loadBoolParam("ispermission")
	expd, expt := bf.loadCommonExpiry()
	contact, _ := bf.f.GetFirstHeader("contact")
	comment, _ := bf.f.GetFirstHeader("comment")
	var revokers [][]byte
	for _, rhash := range bf.f.GetAllHeaders("revoker") {
		rvk, e := crypto.UnFmtHash(rhash)
		if e != nil {
			panic(bwe.M(bwe.MalformedOOBCommand, "bad revoker"))
		}
		revokers = append(revokers, rvk)
	}
	omit := bf.loadBoolParam("omitcreationdate")

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
		mvk, suffix := bf.loadCommonURI()
		perms, ok := bf.f.GetFirstHeader("accesspermissions")
		if !ok {
			panic(bwe.M(bwe.MalformedOOBCommand, "access DOTs require a permission string"))
		}
		p.MVK = mvk
		p.URISuffix = suffix
		p.AccessPermissions = perms
	} else {
		panic(bwe.M(bwe.InvalidOOBCommand, "Application DOTs are not implemented"))
	}
	dot, err := bf.bwcl.CreateDOT(&p)
	if err != nil {
		panic(err)
	}
	r := bf.mkFinalResponseOkayFrame()
	r.AddHeader("hash", crypto.FmtHash(dot.GetHash()))
	df := "0.0.0.32"
	if ispermission {
		df = "0.0.0.33"
	}
	po, err := objects.CreateOpaquePayloadObjectDF(df, dot.GetContent())
	if err != nil {
		panic(err)
	}
	r.AddPayloadObject(po)
	bf.send(r)
}
func (bf *boundFrame) cmdSetEntity() {
	if len(bf.f.POs) != 1 {
		panic(bwe.M(bwe.MalformedOOBCommand, "expected one PO: the key"))
	}
	po := bf.f.POs[0].PO
	if po.GetPONum() != objects.PONumROEntityWKey {
		panic(bwe.M(bwe.MalformedOOBCommand, "expected ROEntityWKey"))
	}
	ent, err := bf.bwcl.SetEntity(&api.SetEntityParams{Keyfile: po.GetContent()})
	if err == nil {
		r := bf.mkFinalResponseOkayFrame()
		r.AddHeader("status", "okay")
		r.AddHeader("vk", crypto.FmtKey(ent.GetVK()))
		bf.send(r)
	} else {
		panic(err)
	}
}
func (bf *boundFrame) cmdMakeChain() {
	ispermission := bf.loadBoolParam("ispermission")
	unelaborate := bf.loadBoolParam("unelaborate")
	var DOTs []*objects.DOT
	for _, sdhash := range bf.f.GetAllHeaders("dot") {
		dhash, e := crypto.UnFmtHash(sdhash)
		if e != nil {
			panic(bwe.M(bwe.MalformedOOBCommand, "could not parse dot hash"))
		}
		rdot, _, err := bf.bwcl.BW().ResolveDOT(dhash)
		if err != nil {
			panic(bwe.WrapM(bwe.ResolutionFailed, "makechain resolving DOT: ", err))
		}
		DOTs = append(DOTs, rdot)
	}
	p := api.CreateDotChainParams{
		DOTs:         DOTs,
		IsPermission: ispermission,
		UnElaborate:  unelaborate,
	}
	dchain, err := bf.bwcl.CreateDOTChain(&p)
	if err != nil {
		panic(err)
	}
	r := objects.CreateFrame(objects.CmdResult, bf.replyto)
	r.AddHeader("hash", crypto.FmtHash(dchain.GetChainHash()))
	var df string
	switch {
	//XTAG why is this hardcoded FFS who the fuck programmed this
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
		panic(err)
	}
	r.AddPayloadObject(po)
	bf.send(r)
}
func (bf *boundFrame) cmdBuildChain() {
	bf.checkChainAge()
	var to []byte
	mvk, suffix := bf.loadCommonURI()
	perms, ok := bf.f.GetFirstHeader("accesspermissions")
	if !ok {
		panic(bwe.M(bwe.MalformedOOBCommand, "buildchain requires 'accesspermissions' kv"))
	}
	sto, ok := bf.f.GetFirstHeader("to")
	if !ok {
		panic(bwe.M(bwe.MalformedOOBCommand, "buildchain requires 'to' kv"))
	}
	to, e := crypto.UnFmtKey(sto)
	if e != nil {
		panic(bwe.M(bwe.MalformedOOBCommand, "could not parse TO kv"))
	}
	status := make(chan string, 10)
	go func() {
		for s := range status {
			log.Infof("OOB BC S: %s", s)
		}
	}()
	cb := api.NewChainBuilder(bf.bwcl, crypto.FmtKey(mvk)+"/"+suffix, perms, to, status)
	go func() {
		//We are going to change the chain builder to emit results on a channel later
		//so lets emit each result on a different message preemptively
		chains, e := cb.Build()
		fmt.Println("chain build in OOB complete")
		if e != nil {
			log.Criticalf("CB fail: %v", e.Error())
			panic(e)
		}
		rs := objects.CreateFrame(objects.CmdResponse, bf.replyto)
		rs.AddHeader("status", "okay")
		bf.send(rs)
		for _, c := range chains {

			//panic("you need to modify the return value of the chain to include whether or not it exists on the BC, and include enough detail to allow the client to publish it")
			po, err := objects.CreateOpaquePayloadObject(c.GetRONum(), c.GetContent())
			if err != nil {
				panic(err)
			}
			r := objects.CreateFrame(objects.CmdResult, bf.replyto)
			r.AddHeader("finished", "false")
			r.AddHeader("hash", crypto.FmtHash(c.GetChainHash()))
			sfx, err := c.GetAccessURISuffix()
			if err != nil {
				panic(err)
			}
			r.AddHeader("uri", crypto.FmtKey(c.GetMVK())+"/"+sfx)
			r.AddHeader("permissions", c.GetAccessURIPermString())
			r.AddPayloadObject(po)
			bf.send(r)
		}
		fmt.Println("sending no more chains frame")
		rs = objects.CreateFrame(objects.CmdResult, bf.replyto)
		rs.AddHeader("finished", "true")
		bf.send(rs)
	}()
}
