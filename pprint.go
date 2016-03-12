package main

import (
	"fmt"
	"strconv"
	"time"

	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/mgutz/ansi"
)

func istring(level int) string {
	rv := ""
	codes := []string{
		ansi.ColorCode("white+b"),
		ansi.ColorCode("blue+b"),
		ansi.ColorCode("green+b"),
		ansi.ColorCode("yellow+b"),
		ansi.ColorCode("magenta+b"),
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
		ansi.ColorCode("yellow+b"),
		ansi.ColorCode("magenta+b"),
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

func doentity(e *objects.Entity, indent int) {
	fmt.Println(ifstring(indent) + " Entity " + crypto.FmtKey(e.GetVK()))
	if e.SigValid() {
		fmt.Println(istring(indent) + " Signature valid")
	} else {
		fmt.Println(istring(indent) + " Signature INVALID")
	}
	if len(e.GetSK()) != 0 {
		fmt.Println(istring(indent)+" SK: ", crypto.FmtKey(e.GetSK()))
		keysOk := crypto.CheckKeypair(e.GetSK(), e.GetVK())
		if keysOk {
			fmt.Println(istring(indent) + " Keypair: ok")
		} else {
			fmt.Println(istring(indent) + " Keypair: INCONSISTENT")
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
		fmt.Println(istring(indent) + " Expires: " + e.GetExpiry().Format(time.RFC3339))
	}
	for _, rvk := range e.GetRevokers() {
		fmt.Println(istring(indent) + " Revoker:" + crypto.FmtKey(rvk))
	}
}
func dodot(d *objects.DOT, indent int, cl *api.BosswaveClient, resolvers []string) {
	fmt.Println(ifstring(indent) + " DOT " + crypto.FmtHash(d.GetHash()))
	if d.SigValid() {
		fmt.Println(istring(indent) + " Signature valid")
	} else {
		fmt.Println(istring(indent) + " Signature INVALID")
	}
	fmt.Println(istring(indent) + " From: " + crypto.FmtKey(d.GetGiverVK()))
	feo := cl.Resolve(crypto.FmtKey(d.GetGiverVK()), resolvers)
	fe, ok := feo.(*objects.Entity)
	if ok {
		doentity(fe, indent+1)
	} else {
		fmt.Println(ifstring(indent+1) + " Unknown Entity")
	}
	fmt.Println(istring(indent) + " To: " + crypto.FmtKey(d.GetReceiverVK()))
	feo = cl.Resolve(crypto.FmtKey(d.GetReceiverVK()), resolvers)
	fe, ok = feo.(*objects.Entity)
	if ok {
		doentity(fe, indent+1)
	} else {
		fmt.Println(ifstring(indent+1) + " Unknown Entity")
	}
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
	for _, rvk := range d.GetRevokers() {
		fmt.Println(istring(indent) + " Revoker:" + crypto.FmtKey(rvk))
	}
}
func dochain(dc *objects.DChain, indent int, verbose bool, cl *api.BosswaveClient, resolvers []string) {
	fmt.Println(ifstring(indent)+" DChain ", crypto.FmtHash(dc.GetChainHash()))
	if !dc.IsElaborated() {
		fmt.Println(istring(indent) + " Elaborated: False")
	} else {
		fmt.Println(istring(indent) + " Elaborated: True")
		haveall := true
		for i := 0; i < dc.NumHashes(); i++ {
			dh := dc.GetDotHash(i)
			fmt.Printf(istring(indent)+" DOT[%d] = %s\n", i, crypto.FmtHash(dh))
			var dt *objects.DOT
			dt = dc.GetDOT(i)
			if dt == nil {
				dto := cl.Resolve(crypto.FmtHash(dh), resolvers)
				var ok bool
				dt, ok = dto.(*objects.DOT)
				if !ok {
					dt = nil
				}
			}
			if dt != nil {
				dc.SetDOT(i, dt)
				if verbose {
					dodot(dt, indent+1, cl, resolvers)
				}

			} else {
				haveall = false
				if verbose {
					fmt.Println(ifstring(indent+1) + " DOT is not resolvable")
				}
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
