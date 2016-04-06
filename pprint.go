package main

import (
	"fmt"
	"math/big"
	"strconv"
	"time"

	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2bind"
	"github.com/mgutz/ansi"
)

func istring(level int) string {
	rv := ""
	codes := []string{
		ansi.ColorCode("white+b"),
		ansi.ColorCode("blue+b"),
		ansi.ColorCode("green+b"),
		ansi.ColorCode("magenta+b"),
		ansi.ColorCode("yellow+b"),
	}

	for i := 0; i < level-1; i++ {
		rv += codes[i] + "\u2503"
	}
	return rv + codes[level-1] + "\u2523"
}
func ifstring(level int) string {
	rv := ""
	codes := []string{
		ansi.ColorCode("white+b"),
		ansi.ColorCode("blue+b"),
		ansi.ColorCode("green+b"),
		ansi.ColorCode("magenta+b"),
		ansi.ColorCode("yellow+b"),
	}

	for i := 0; i < level-2; i++ {
		rv += codes[i] + "\u2503"
	}
	if level >= 2 {
		return rv + codes[level-2] + "\u2523" + codes[level-1] + "\u2533"
	} else {
		return codes[level-1] + "\u2533"
	}
}
func resetTerm() {
	fmt.Print(ansi.ColorCode("reset"))
}
func doentityfile(e *objects.Entity, cl *bw2bind.BW2Client) {
	//Do this so you can get registry messages even for files
	_, status, xerr := cl.ResolveRegistry(crypto.FmtKey(e.GetVK()))
	regnote := cl.ValidityToString(status, xerr)
	doentityobj(e, 2, regnote, cl)
}
func doentityobj(e *objects.Entity, indent int, regnote string, cl *bw2bind.BW2Client) {
	//TODO clean this func up a little to be not copypasta
	fmt.Println(ifstring(indent) + " Entity VK=" + crypto.FmtKey(e.GetVK()))
	if e.SigValid() {
		fmt.Println(istring(indent) + " Signature: valid")
	} else {
		fmt.Println(istring(indent) + ansi.ColorCode("red+b") + " SIGNATURE INVALID")
	}
	if regnote != "valid" {
		regnote = ansi.ColorCode("red+b") + regnote
	}
	fmt.Println(istring(indent) + " Registry: " + regnote)

	if len(e.GetSK()) != 0 {
		fmt.Println(istring(indent)+" SK:", crypto.FmtKey(e.GetSK()))
		keysOk := crypto.CheckKeypair(e.GetSK(), e.GetVK())
		if keysOk {
			fmt.Println(istring(indent) + " Keypair: ok")
		} else {
			fmt.Println(istring(indent) + ansi.ColorCode("red+b") + " KEYPAIR INCONSISTENT")
		}
		cl.SetEntity(e.GetSigningBlob())
		accbal, err := cl.EntityBalances()
		if err != nil {
			fmt.Println(istring(indent) + " Balances:" + ansi.ColorCode("red+b") + " ERROR: " + err.Error())
		} else {
			fmt.Println(istring(indent) + " Balances: ")
			for i, bal := range accbal {
				f := big.NewFloat(0)
				f.SetInt(bal.Int)
				f = f.Quo(f, big.NewFloat(1000000000000000000.0))
				fmt.Println(istring(indent+1) + fmt.Sprintf(" %2d (%s) %.6f \u039e", i, bal.Addr, f))
			}
		}
	}
	if len(e.GetContact()) != 0 {
		fmt.Println(istring(indent) + " Contact: " + e.GetContact())
	}
	if len(e.GetComment()) != 0 {
		fmt.Println(istring(indent) + " Comment: " + e.GetComment())
	}
	if e.GetCreated() != nil {
		fmt.Println(istring(indent) + " Created: " + e.GetCreated().Format(time.RFC3339))
	}
	if e.GetExpiry() != nil {
		if e.GetExpiry().Before(time.Now()) {
			fmt.Println(istring(indent) + ansi.ColorCode("red+b") + " EXPIRED: " + e.GetExpiry().Format(time.RFC3339))
		} else {
			fmt.Println(istring(indent) + " Expires: " + e.GetExpiry().Format(time.RFC3339))
		}
	}
	for idx, rvk := range e.GetRevokers() {
		fmt.Println(istring(indent) + fmt.Sprintf(" Revoker[%d]:", idx))
		doentity(rvk, indent+1, cl)
	}
}
func doentity(vk []byte, indent int, cl *bw2bind.BW2Client) {
	ei, status, xerr := cl.ResolveRegistry(crypto.FmtKey(vk))
	regnote := cl.ValidityToString(status, xerr)
	if ei == nil {
		fmt.Println(ifstring(indent) + " UNKNOWN ENTITY, VK=" + crypto.FmtKey(vk))
		return
	}
	e, ok := ei.(*objects.Entity)
	if !ok {
		fmt.Println(ifstring(indent) + ansi.ColorCode("red+b") + fmt.Sprintf(" RO TYPE MISMATCH, EXPECT ENTITY GOT %+v\n", ei))
		return
	}
	doentityobj(e, indent, regnote, cl)
}
func dodotfile(d *objects.DOT, cl *bw2bind.BW2Client) {
	//Do this so you can get registry messages even for files
	_, status, xerr := cl.ResolveRegistry(crypto.FmtKey(d.GetHash()))
	regnote := cl.ValidityToString(status, xerr)
	dodotobj(d, 2, regnote, cl)
}
func dodot(hash []byte, indent int, cl *bw2bind.BW2Client) {
	di, status, xerr := cl.ResolveRegistry(crypto.FmtKey(hash))
	regnote := cl.ValidityToString(status, xerr)
	if di == nil {
		fmt.Println(ifstring(indent) + " UNKNOWN DOT, HASH=" + crypto.FmtKey(hash))
		return
	}
	d, ok := di.(*objects.DOT)
	if !ok {
		fmt.Println(ifstring(indent) + ansi.ColorCode("red+b") + fmt.Sprintf(" RO TYPE MISMATCH, EXPECT DOT GOT %+v\n", di))
		return
	}
	dodotobj(d, indent, regnote, cl)
}
func dodotobj(d *objects.DOT, indent int, regnote string, cl *bw2bind.BW2Client) {
	fmt.Println(ifstring(indent) + " DOT " + crypto.FmtHash(d.GetHash()))
	if d.SigValid() {
		fmt.Println(istring(indent) + " Signature: valid")
	} else {
		fmt.Println(istring(indent) + ansi.ColorCode("red+b") + " SIGNATURE INVALID")
	}
	if regnote != "valid" {
		regnote = ansi.ColorCode("red+b") + regnote
	}
	fmt.Println(istring(indent) + " Registry: " + regnote)
	fmt.Println(istring(indent) + " From: ")
	doentity(d.GetGiverVK(), indent+1, cl)
	fmt.Println(istring(indent) + " To: ")
	doentity(d.GetReceiverVK(), indent+1, cl)
	//TODO reverse alias lookup
	if d.IsAccess() {
		fmt.Println(istring(indent) + " URI: " + crypto.FmtKey(d.GetAccessURIMVK()) + "/" + d.GetAccessURISuffix())
		fmt.Println(istring(indent) + " Permissions: " + d.GetPermString())
	}
	if len(d.GetContact()) != 0 {
		fmt.Println(istring(indent) + " Contact: " + d.GetContact())
	}
	if len(d.GetComment()) != 0 {
		fmt.Println(istring(indent) + " Comment: " + d.GetComment())
	}
	if d.GetCreated() != nil {
		fmt.Println(istring(indent) + " Created: " + d.GetCreated().Format(time.RFC3339))
	}
	if d.GetExpiry() != nil {
		fmt.Println(istring(indent) + " Expires: " + d.GetExpiry().Format(time.RFC3339))
	}
	fmt.Println(istring(indent) + fmt.Sprintf(" TTL: %d", d.GetTTL()))
	for idx, rvk := range d.GetRevokers() {
		fmt.Println(istring(indent) + fmt.Sprintf(" Revoker[%d]:", idx))
		doentity(rvk, indent+1, cl)
	}
}
func dochain(hash []byte, indent int, verbose bool, cl *bw2bind.BW2Client) {
	ci, status, xerr := cl.ResolveRegistry(crypto.FmtKey(hash))
	regnote := cl.ValidityToString(status, xerr)
	if ci == nil {
		fmt.Println(ifstring(indent) + " UNKNOWN CHAIN, HASH=" + crypto.FmtKey(hash))
		return
	}
	c, ok := ci.(*objects.DChain)
	if !ok {
		fmt.Println(ifstring(indent) + ansi.ColorCode("red+b") + fmt.Sprintf(" RO TYPE MISMATCH, EXPECT DCHAIN GOT %+v\n", ci))
		return
	}
	dochainobj(c, indent, verbose, regnote, cl)
}
func dochainfile(dc *objects.DChain, cl *bw2bind.BW2Client) {
	//Do this so you can get registry messages even for files
	_, status, xerr := cl.ResolveRegistry(crypto.FmtKey(dc.GetChainHash()))
	regnote := cl.ValidityToString(status, xerr)
	dochainobj(dc, 2, true, regnote, cl)
}
func dochainobj(dc *objects.DChain, indent int, verbose bool, regnote string, cl *bw2bind.BW2Client) {
	fmt.Println(ifstring(indent)+" DChain hash=", crypto.FmtHash(dc.GetChainHash()))
	if regnote != "valid" {
		regnote = ansi.ColorCode("red+b") + regnote
	}
	fmt.Println(istring(indent) + " Registry: " + regnote)
	if !dc.IsElaborated() {
		fmt.Println(istring(indent) + " Elaborated: False")
	} else {
		fmt.Println(istring(indent) + " Elaborated: True")
		haveall := true
		for i := 0; i < dc.NumHashes(); i++ {
			dh := dc.GetDotHash(i)
			di, _, _ := cl.ResolveRegistry(crypto.FmtKey(dh))
			if verbose {
				fmt.Printf(istring(indent)+" DOT[%d]:\n", i)
				dodot(dh, indent+1, cl)
			}
			if di != nil {
				d, ok := di.(*objects.DOT)
				if !ok {
					fmt.Println(ifstring(indent) + ansi.ColorCode("red+b") + fmt.Sprintf(" RO TYPE MISMATCH, EXPECT DCHAIN GOT %+v\n", di))
					return
				}
				dc.SetDOT(i, d)
			} else {
				haveall = false
			}
		}
		if haveall {
			fmt.Println(istring(indent) + " Grants: " + dc.GetAccessURIPermString())
			suffix, err := dc.GetAccessURISuffix()
			if err != nil {
				fmt.Println(istring(indent) + " On: <NOTHING!>")
			} else {
				fmt.Println(istring(indent) + " On: " + crypto.FmtKey(dc.GetMVK()) + "/" + suffix)
			}
			fmt.Println(istring(indent) + " End TTL: " + strconv.Itoa(dc.GetTTL()))
		} else {
			fmt.Println(istring(indent) + " TTL/Grant/URI unknown (missing DOTs)")
		}
	}
}
