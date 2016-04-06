package oob

import (
	"fmt"
	"math/big"
	"strconv"

	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/bc"
	"github.com/immesys/bw2/crypto"
	_ "github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util/bwe"
)

/*
CmdPutDot       = "putd"
CmdPutEntity    = "pute"
CmdPutChain     = "putc"
CmdEntityBalances      = "ebal"
CmdAddressBalance      = "abal"
CmdBCInteractionParams = "bcip"
CmdTransfer            = "xfer"
CmdMakeShortAlias      = "mksa"
CmdMakeLongAlias       = "mkla"
CmdResolveAlias        = "resa"
CmdNewDROffer          = "ndro"
CmdAcceptDROffer       = "adro"
CmdResolveAnything     = "resx"
*/

func (bf *boundFrame) cmdPutDot() {
	bf.checkChainAge()
	acc := bf.loadAccount()
	po := bf.f.POs[0].PO
	if po.GetPONum() != objects.PONumROAccessDOT {
		panic(bwe.M(bwe.MalformedOOBCommand, "expected ROAccessDOT"))
	}
	dti, err := objects.LoadRoutingObject(objects.ROAccessDOT, po.GetContent())
	if err != nil {
		panic(bwe.WrapM(bwe.MalformedOOBCommand, "Could not load DOT: ", err))
	}
	dt := dti.(*objects.DOT)
	bf.bwcl.BCC().PublishDOT(acc, dt, func(err error) {
		if err != nil {
			bf.Err(err)
		} else {
			r := bf.mkFinalResponseOkayFrame()
			r.AddHeader("hash", crypto.FmtHash(dt.GetHash()))
			bf.send(r)
		}
	})
}
func (bf *boundFrame) cmdPutEntity() {
	bf.checkChainAge()
	acc := bf.loadAccount()
	po := bf.f.POs[0].PO
	if po.GetPONum() != objects.PONumROEntity && po.GetPONum() != objects.PONumROEntityWKey {
		panic(bwe.M(bwe.MalformedOOBCommand, "expected an entity PO"))
	}
	enti, err := objects.LoadRoutingObject(po.GetPONum(), po.GetContent())
	if err != nil {
		panic(bwe.WrapM(bwe.MalformedOOBCommand, "Could not load Entity", err))
	}
	ent := enti.(*objects.Entity)
	bf.bwcl.BCC().PublishEntity(acc, ent, func(err error) {
		if err != nil {
			bf.Err(err)
		} else {
			r := bf.mkFinalResponseOkayFrame()
			r.AddHeader("vk", crypto.FmtKey(ent.GetVK()))
			bf.send(r)
		}
	})
}
func (bf *boundFrame) cmdPutChain() {
	bf.checkChainAge()
	acc := bf.loadAccount()
	po := bf.f.POs[0].PO
	if po.GetPONum() != objects.PONumROAccessDChain {
		panic(bwe.M(bwe.MalformedOOBCommand, "expected an ROAccessDCHain"))
	}
	dci, err := objects.LoadRoutingObject(po.GetPONum(), po.GetContent())
	if err != nil {
		panic(bwe.WrapM(bwe.MalformedOOBCommand, "Could not load DChain: ", err))
	}
	dc := dci.(*objects.DChain)
	bf.bwcl.BCC().PublishAccessDChain(acc, dc, func(err error) {
		if err != nil {
			bf.Err(err)
		} else {
			r := bf.mkFinalResponseOkayFrame()
			r.AddHeader("hash", crypto.FmtHash(dc.GetChainHash()))
			bf.send(r)
		}
	})
}
func (bf *boundFrame) cmdEntityBalances() {
	bf.checkChainAge()
	r := bf.mkFinalResponseOkayFrame()
	for i := 0; i < bc.MaxEntityAccounts; i++ {
		addr, err := bf.bwcl.BCC().GetAddress(i)
		if err != nil {
			panic(err)
		}
		decimal, human, err := bf.bwcl.BCC().GetBalance(i)
		if err != nil {
			panic(err)
		}
		accbal := fmt.Sprintf("0x%s,%s,%s", addr.Hex(), decimal, human)
		po, err := objects.CreateOpaquePayloadObject(objects.PONumAccountBalance, []byte(accbal))
		if err != nil {
			panic(err)
		}
		r.AddPayloadObject(po)
	}
	bf.send(r)
}
func (bf *boundFrame) cmdAddressBalance() {
	bf.checkChainAge()
	r := bf.mkFinalResponseOkayFrame()
	address, ok := bf.f.GetFirstHeader("address")
	if !ok {
		panic(bwe.M(bwe.InvalidOOBCommand, "Missing kv(address)"))
	}
	decimal, human := bf.bwcl.BC().GetAddrBalance(address)

	accbal := fmt.Sprintf("0x%s,%s,%s", address, decimal, human)
	po, err := objects.CreateOpaquePayloadObject(objects.PONumAccountBalance, []byte(accbal))
	if err != nil {
		panic(err)
	}
	r.AddPayloadObject(po)
	bf.send(r)
}
func (bf *boundFrame) cmdBCInteractionParams() {
	bf.checkHaveChain()
	conf, hasconf, emsg := bf.f.ParseFirstHeaderAsInt("confirmations", 0)
	if emsg != nil {
		panic(bwe.M(bwe.InvalidOOBCommand, "bad kv(confirmations)"))
	}
	timo, hastimo, emsg := bf.f.ParseFirstHeaderAsInt("timeout", 0)
	if emsg != nil || timo < 0 {
		panic(bwe.M(bwe.InvalidOOBCommand, "bad kv(timeout)"))
	}
	maxa, hasmaxa, emsg := bf.f.ParseFirstHeaderAsInt("maxage", 0)
	if emsg != nil || maxa < 0 {
		panic(bwe.M(bwe.InvalidOOBCommand, "bad kv(maxage)"))
	}
	if hasconf {
		bf.bwcl.BCC().SetDefaultConfirmations(uint64(conf))
	}
	if hastimo {
		bf.bwcl.BCC().SetDefaultTimeout(uint64(timo))
	}
	if hasmaxa {
		bf.bwcl.SetMaxChainAge(uint64(maxa))
	}
	r := bf.mkFinalResponseOkayFrame()
	r.AddHeader("confirmations", strconv.FormatUint(bf.bwcl.BCC().GetDefaultConfirmations(), 10))
	r.AddHeader("timeout", strconv.FormatUint(bf.bwcl.BCC().GetDefaultTimeout(), 10))
	r.AddHeader("maxage", strconv.FormatUint(bf.bwcl.GetMaxChainAge(), 10))
	r.AddHeader("currentage", strconv.FormatInt(bf.bwcl.BC().HeadBlockAge(), 10))
	r.AddHeader("currentblock", strconv.FormatInt(int64(bf.bwcl.BC().CurrentBlock()), 10))
	bf.send(r)
}
func (bf *boundFrame) cmdTransfer() {
	bf.checkChainAge()
	acc := bf.loadAccount()
	addr, addrok := bf.f.GetFirstHeader("address")
	if !addrok {
		panic(bwe.M(bwe.InvalidOOBCommand, "bad kv(address)"))
	}
	valwei, haveValWei := bf.f.GetFirstHeader("valuewei")
	valfin, haveValFin := bf.f.GetFirstHeader("valuefinney")
	value, haveValue := bf.f.GetFirstHeader("value")
	bigValue := big.NewInt(0)
	set := false
	if haveValWei {
		bigValue.SetString(valwei, 10)
		set = true
	}
	if haveValFin {
		bigValue.SetString(valfin, 10)
		bigValue.Mul(bigValue, big.NewInt(1000000000000000))
		if set {
			panic(bwe.M(bwe.InvalidOOBCommand, "more than one value set"))
		}
		set = true
	}
	if haveValue {
		bigValue.SetString(value, 10)
		bigValue.Mul(bigValue, big.NewInt(1000000000000000))
		bigValue.Mul(bigValue, big.NewInt(1000))
		if set {
			panic(bwe.M(bwe.InvalidOOBCommand, "more than one value set"))
		}
		set = true
	}
	if !set {
		panic(bwe.M(bwe.InvalidOOBCommand, "no value set"))
	}
	gas, _ := bf.f.GetFirstHeader("gas")
	gasprice, _ := bf.f.GetFirstHeader("gasprice")
	data, _ := bf.f.GetFirstHeader("data")
	bf.bwcl.BCC().TransactAndCheck(acc, addr, bigValue.Text(10), gas, gasprice, data,
		bf.mkFinalGenericActionCB())
}
func (bf *boundFrame) cmdMakeShortAlias() {
	bf.checkChainAge()
	acc := bf.loadAccount()
	content, contentok := bf.f.GetFirstHeaderB("content")
	if !contentok {
		panic(bwe.M(bwe.InvalidOOBCommand, "missing content kv"))
	}
	if len(content) > 32 {
		content = content[:32]
	}
	bf.bwcl.BCC().CreateShortAlias(acc, bc.SliceToBytes32(content), func(alias uint64, err error) {
		if err != nil {
			bf.Err(err)
		} else {
			r := bf.mkFinalResponseOkayFrame()
			r.AddHeader("hexkey", fmt.Sprintf("%x", alias))
			bf.send(r)
		}
	})
}
func (bf *boundFrame) cmdMakeLongAlias() {
	bf.checkChainAge()
	acc := bf.loadAccount()
	content, contentok := bf.f.GetFirstHeaderB("content")
	if !contentok {
		panic(bwe.M(bwe.InvalidOOBCommand, "missing content kv"))
	}
	if len(content) > 32 {
		content = content[:32]
	}
	key, keyok := bf.f.GetFirstHeaderB("key")
	if !keyok {
		panic(bwe.M(bwe.InvalidOOBCommand, "missing key kv"))
	}
	if len(key) > 32 {
		key = key[:32]
	}
	bf.bwcl.BCC().SetAlias(acc, bc.SliceToBytes32(key), bc.SliceToBytes32(content),
		bf.mkFinalGenericActionCB())
}
func (bf *boundFrame) cmdResolveAlias() {
	bf.checkChainAge()
	longkey, longkeyok := bf.f.GetFirstHeader("longkey")
	shortkey, shortkeyok := bf.f.GetFirstHeader("shortkey")
	embedded, embeddedok := bf.f.GetFirstHeader("embedded")
	got := false
	var value []byte
	if longkeyok {
		got = true
		var err error
		value, err = bf.bwcl.BW().ResolveLongAlias(longkey)
		if err != nil {
			panic(err)
		}
	}
	if shortkeyok {
		if got {
			panic(bwe.M(bwe.InvalidOOBCommand, "too many kv's"))
		}
		got = true
		var err error
		value, err = bf.bwcl.BW().ResolveShortAlias(shortkey)
		if err != nil {
			panic(err)
		}
	}
	if embeddedok {
		if got {
			panic(bwe.M(bwe.InvalidOOBCommand, "too many kv's"))
		}
		valueS, err := bf.bwcl.BW().ExpandAliases(embedded)
		if err != nil {
			panic(err)
		}
		value = []byte(valueS)
	}
	r := bf.mkFinalResponseOkayFrame()
	r.AddHeader("value", string(value))
	bf.send(r)
}
func (bf *boundFrame) cmdNewDesignatedRouterOffer() {
	bf.checkChainAge()
	acc := bf.loadAccount()
	ent := bf.loadEntityPoOrUs()
	nsvkS, nsvkok := bf.f.GetFirstHeader("nsvk")
	if !nsvkok {
		panic(bwe.M(bwe.InvalidOOBCommand, "missing kv(nsvk)"))
	}
	nsvk, err := bf.bwcl.BW().ResolveKey(nsvkS)
	if err != nil {
		panic(err)
	}
	bf.bwcl.BCC().CreateRoutingOffer(acc, ent, nsvk, bf.mkFinalGenericActionCB())
}
func (bf *boundFrame) cmdUpdateSRVRecord() {
	bf.checkChainAge()
	acc := bf.loadAccount()
	ent := bf.loadEntityPoOrUs()
	srv, srvok := bf.f.GetFirstHeader("srv")
	if !srvok {
		panic(bwe.M(bwe.InvalidOOBCommand, "missing kv(srv)"))
	}
	bf.bwcl.BCC().CreateSRVRecord(acc, ent, srv, bf.mkFinalGenericActionCB())
}

func (bf *boundFrame) cmdListDesignatedRouterOffers() {
	bf.checkChainAge()
	nsvkS, nsvkok := bf.f.GetFirstHeader("nsvk")
	if !nsvkok {
		panic(bwe.M(bwe.InvalidOOBCommand, "missing kv(nsvk)"))
	}
	nsvk, err := bf.bwcl.BW().ResolveKey(nsvkS)
	if err != nil {
		panic(err)
	}
	chosen, err := bf.bwcl.BW().BC().GetDesignatedRouterFor(nsvk)
	var srv string
	var srve error
	if err == nil {
		srv, srve = bf.bwcl.BW().LookupDesignatedRouterSRV(chosen)
	}
	fmt.Printf("err=%v chosen='%v', srve='%v' srv='%v'\n", err, crypto.FmtKey(chosen), srve, srv)
	drvks := bf.bwcl.BW().BC().FindRoutingOffers(nsvk)
	r := bf.mkFinalResponseOkayFrame()
	if err == nil {
		r.AddHeader("active", crypto.FmtKey(chosen))
		if srve == nil {
			r.AddHeader("srv", srv)
		}
	}
	for _, dr := range drvks {
		po, err := objects.CreateOpaquePayloadObject(objects.RODesignatedRouterVK, dr)
		if err != nil {
			panic(err)
		}
		r.AddPayloadObject(po)
	}
	bf.send(r)

}
func (bf *boundFrame) cmdAcceptDesignatedRouterOffer() {
	bf.checkChainAge()
	acc := bf.loadAccount()
	ent := bf.loadEntityPoOrUs()
	fmt.Println("loadEntityPoOrUs is ", crypto.FmtKey(ent.GetVK()))
	drvkS, drvkok := bf.f.GetFirstHeader("drvk")
	if !drvkok {
		panic(bwe.M(bwe.InvalidOOBCommand, "missing kv(drvk)"))
	}
	drvk, err := bf.bwcl.BW().ResolveKey(drvkS)
	if err != nil {
		panic(err)
	}
	bf.bwcl.BCC().AcceptRoutingOffer(acc, ent, drvk, bf.mkFinalGenericActionCB())
}

func (bf *boundFrame) cmdResolveRegistryObject() {
	bf.checkChainAge()
	key, keyok := bf.f.GetFirstHeader("key")
	if !keyok {
		panic(bwe.M(bwe.InvalidOOBCommand, "missing kv(key)"))
	}
	ro, state, err := bf.bwcl.BW().ResolveRO(key)
	if state == api.StateError {
		panic(bwe.WrapM(bwe.ResolutionFailed, "could not resolve RO", err))
	}
	r := bf.mkFinalResponseOkayFrame()
	if ro != nil {
		r.AddRoutingObject(ro)
	}
	switch state {
	case api.StateUnknown:
		r.AddHeader("validity", "unknown")
	case api.StateValid:
		r.AddHeader("validity", "valid")
	case api.StateExpired:
		r.AddHeader("validity", "expired")
	case api.StateRevoked:
		r.AddHeader("validity", "revoked")
	default:
		panic(bwe.M(bwe.BadOperation, "This should not have happened"))
	}
	bf.send(r)
}
