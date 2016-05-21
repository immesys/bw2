package main

import (
	"bytes"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"io/ioutil"
	"math/big"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"
	"unicode/utf8"

	log "github.com/cihub/seelog"
	"github.com/codegangsta/cli"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util"
	"github.com/immesys/bw2/util/coldstore"
	"github.com/immesys/bw2bind"
	"github.com/mgutz/ansi"
)

func silencelog() {
	cfg := `
	<seelog>
    <outputs>
        <splitter formatid="common">
            <file path="/tmp/bw2clilog"/>
        </splitter>
    </outputs>
		<formats>
				<format id="common" format="[%LEV] %Time %Date %File:%Line %Msg%n"/>
		</formats>
	</seelog>`

	nlogger, err := log.LoggerFromConfigAsString(cfg)
	if err == nil {
		log.ReplaceLogger(nlogger)
	} else {
		fmt.Printf("Bad log config: %v\n", err)
		os.Exit(1)
	}
}
func loadSigningEntityFile(fpath string) *objects.Entity {
	contents, err := ioutil.ReadFile(fpath)
	if err != nil {
		return nil
	}
	if contents[0] != objects.ROEntityWKey {
		return nil
	}
	enti, err := objects.NewEntity(int(contents[0]), contents[1:])
	if err != nil {
		return nil
	}
	ent, ok := enti.(*objects.Entity)
	if !ok {
		return nil
	}
	ent.Encode()
	return ent
}

func getAvailableEntity(c *cli.Context, param string) *objects.Entity {
	//Try it first as a file
	se := loadSigningEntityFile(param)
	if se != nil {
		return se
	}
	aents := make([]*objects.Entity, 0)
	for _, aefile := range c.GlobalStringSlice("a") {
		ent := loadSigningEntityFile(aefile)
		if ent == nil {
			fmt.Printf("Could not load available entity '%s'\n", aefile)
			os.Exit(1)
		}
		aents = append(aents, ent)
	}
	//First try match on VK directly
	binvk, err := crypto.UnFmtKey(param)
	if err == nil {
		for _, e := range aents {
			if bytes.Equal(e.GetVK(), binvk) {
				return e
			}
		}
	}
	//Next match alias
	//TODO
	return nil
}
func getBankroll(c *cli.Context, bwcl *bw2bind.BW2Client) []byte {

	par := c.String("bankroll")

	if par == "" {
		fmt.Println("No bankroll entity specified")
		os.Exit(1)
	}
	enti, ok := getEntityParam(bwcl, c, par, true)
	if !ok {
		fmt.Printf("Could not load bankroll entity '%s'\n", par)
		os.Exit(1)
	}
	return enti.(*objects.Entity).GetSigningBlob()
}

func getAccountParam(bwcl *bw2bind.BW2Client, c *cli.Context, param string) string {
	if param == "" {
		fmt.Printf("Account parameter missing\n")
		os.Exit(1)
	}
	//First try it as an entity file:
	se := loadSigningEntityFile(param)
	if se != nil {
		rv, _ := coldstore.GetAccountHex(se,0)
		return rv
	}
	//Then try it as hex directly
	hparam := param
	if hparam[0:2] == "0x" {
		hparam = hparam[2:]
	}
	if len(hparam) == 40 {
		return "0x" + hparam
	}
	//Then try it as an alias
	res, zero, err := bwcl.ResolveLongAlias(param)
	if err != nil {
		fmt.Printf("Could not resolve alias '%s': %s\n", param, err.Error())
		os.Exit(1)
	}
	if zero {
		fmt.Printf("Could not decode '%s' as a keyfile, hex or alias\n", param)
		os.Exit(1)
	}
	for i := 20; i < 32; i++ {
		if res[i] != 0 {
			fmt.Printf("Alias '%s' is not an account address\n", param)
			os.Exit(1)
		}
	}
	return "0x" + hex.EncodeToString(res[:20])
}

func getEntityParamVK(bwcl *bw2bind.BW2Client, c *cli.Context, param string) (string, bool) {
	i, ok := getEntityParam(bwcl, c, param, false)
	if ok {
		return i.(string), true
	}
	return "", false
}
func getEntityParam(bwcl *bw2bind.BW2Client, c *cli.Context, param string, asSK bool) (interface{}, bool) {
	//First thing we do is check if there is a local file by that name
	contents, err := ioutil.ReadFile(param)
	if err != nil && !os.IsNotExist(err) {
		//If file exists but cannot be read, then error out
		fmt.Println("Could not read file", param, ":", err.Error())
		os.Exit(1)
	}
	if contents != nil {
		if asSK && contents[0] != objects.ROEntityWKey {
			fmt.Println("Need signing entity:", param)
			os.Exit(1)
		}
		enti, err := objects.NewEntity(int(contents[0]), contents[1:])
		if err != nil {
			fmt.Println("Could not decode file:", param, ":", err.Error())
			os.Exit(1)
		}
		ent, ok := enti.(*objects.Entity)
		if !ok {
			fmt.Println("Could not decode file:", param)
			os.Exit(1)
		}
		if asSK {
			return ent, true
		} else {
			return crypto.FmtKey(ent.GetVK()), true
		}
	}

	//It was not a file
	if asSK {
		//We need to get it from available entities:
		ent := getAvailableEntity(c, param)
		if ent != nil {
			return ent, true
		} else {
			//No other options
			fmt.Printf("Could not resolve '%s' to a signing entity\n", param)
			os.Exit(1)
		}
	} else {
		//Just a VK will do. Check if it is already one:
		_, err := crypto.UnFmtKey(param)
		if err == nil {
			return param, true
		}

		//Only option is an alias
		ro, _, err := bwcl.ResolveRegistry(param)
		if err != nil {
			fmt.Printf("Could not resolve '%s' in registry: %v\n", param, err)
			os.Exit(1)
		}
		ent, ok := ro.(*objects.Entity)
		if !ok {
			fmt.Printf("Could not load '%s' as an entity\n", param)
			os.Exit(1)
		}
		return crypto.FmtKey(ent.GetVK()), true

	}
	return nil, false
}
func actionColdStore(c *cli.Context) {
	cl := bw2bind.ConnectOrExit("")
	cscode := ""
	for _, v := range c.Args() {
		cscode += v
	}
	if len(cscode) != 16 {
		fmt.Println("Invalid coldstore code")
		os.Exit(1)
	}
	bin, err := hex.DecodeString(cscode)
	if err != nil {
		fmt.Println("Invalid coldstore code:", err.Error())
		os.Exit(1)
	}
	ent := coldstore.DecodeColdStore(bin)
	cl.SetEntityOrExit(ent.GetSigningBlob())
	accbal, err := cl.EntityBalances()
	bal := accbal[0]
	if err != nil {
		fmt.Println("Balance:" + ansi.ColorCode("red+b") + " ERROR: " + err.Error())
	} else {
		fmt.Println("Balance: ")
		f := big.NewFloat(0)
		f.SetInt(bal.Int)
		f = f.Quo(f, big.NewFloat(1000000000000000000.0))
		fmt.Println(fmt.Sprintf(" (%s) %.6f \u039e", bal.Addr, f))
	}

	if c.String("to") != "" {
		toacc := getAccountParam(cl, c, c.String("to"))
		amt := bal.Int
		amt = amt.Sub(amt, big.NewInt(100000000000000000)) //100 finney
		if amt.Sign() <= 0 {
			fmt.Println("Insufficient coldstore balance to do transfer")
			os.Exit(1)
		}
		dchan := make(chan string, 1)
		go func() {
			//err := cl.Transfer(toacc, 1*bw2bind.Ether)
			err := cl.TransferWei(0, toacc, amt)
			if err == nil {
				dchan <- "Transfer completed and confirmed"
			} else {
				dchan <- "Transfer error: " + err.Error()
			}
		}()
		doChainOp(cl, dchan)
	} else {
		fmt.Println("no 'to' account specified, not transferring")
	}
}
func actionMkDRO(c *cli.Context) {
	cl := bw2bind.ConnectOrExit("")
	nsp := c.String("ns")
	if nsp == "" {
		fmt.Println("'ns' parameter required")
		os.Exit(1)
	}
	ns, ok := getEntityParamVK(cl, c, nsp)
	if !ok {
		fmt.Println("Could not resolve ns param")
		os.Exit(1)
	}
	dr := getAvailableEntity(c, c.String("dr"))
	if dr == nil {
		fmt.Println("Could not load designated router")
		os.Exit(1)
	}
	//If a bankroll is specified, we will use that to pay
	if c.String("bankroll") != "" {
		br := getBankroll(c, cl)
		cl.SetEntity(br)
	} else {
		cl.SetEntity(dr.GetSigningBlob())
	}
	dchan := make(chan string, 1)
	go func() {
		err := cl.NewDesignatedRouterOffer(0, ns, dr)
		if err == nil {
			dchan <- "Designated router offer created and confirmed"
		} else {
			dchan <- "DRO error: " + err.Error()
		}
	}()
	doChainOp(cl, dchan)
}
func actionLsDRO(c *cli.Context) {
	cl := bw2bind.ConnectOrExit("")
	nsp := c.String("ns")
	if nsp == "" {
		fmt.Println("'ns' parameter required")
		os.Exit(1)
	}
	ns, ok := getEntityParamVK(cl, c, nsp)
	if !ok {
		fmt.Println("Could not resolve ns param")
		os.Exit(1)
	}
	active, srv, all, err := cl.GetDesignatedRouterOffers(ns)
	if err != nil {
		fmt.Println("Search failed:", err.Error())
		os.Exit(1)
	}
	if active == "" {
		fmt.Println("No accepted offers found")
	} else {
		fmt.Printf("Active affinity: \n  NS : %s\n  DR : %s\n SRV : %s\n", ns, active, srv)
	}
	if len(all) == 0 {
		fmt.Println("No open offers found")
	} else {
		fmt.Printf("There are %d open offers:\n", len(all))
		for _, o := range all {
			fmt.Println(" " + o)
		}
	}
}
func actionADRO(c *cli.Context) {
	cl := bw2bind.ConnectOrExit("")
	drp := c.String("dr")
	if drp == "" {
		fmt.Println("'dr' parameter required")
		os.Exit(1)
	}
	dr, ok := getEntityParamVK(cl, c, drp)
	if !ok {
		fmt.Println("Could not resolve dr param")
		os.Exit(1)
	}
	ns := getAvailableEntity(c, c.String("ns"))
	if ns == nil {
		fmt.Println("Could not load 'ns' entity")
		os.Exit(1)
	}
	//If a bankroll is specified, we will use that to pay
	if c.String("bankroll") != "" {
		br := getBankroll(c, cl)
		cl.SetEntity(br)
	} else {
		cl.SetEntity(ns.GetSigningBlob())
	}
	dchan := make(chan string, 1)
	go func() {
		err := cl.AcceptDesignatedRouterOffer(0, dr, ns)
		if err == nil {
			dchan <- "Designated router offer accepted and confirmed"
		} else {
			dchan <- "Error accepting routing offer: " + err.Error()
		}
	}()
	doChainOp(cl, dchan)
}
func actionUSRV(c *cli.Context) {
	cl := bw2bind.ConnectOrExit("")
	srv := c.String("srv")
	if srv == "" {
		fmt.Println("'srv' parameter required")
		os.Exit(1)
	}
	if c.String("dr") == "" {
		fmt.Println("'dr' parameter required")
		os.Exit(1)
	}
	dr := getAvailableEntity(c, c.String("dr"))

	//If a bankroll is specified, we will use that to pay
	if c.String("bankroll") != "" {
		br := getBankroll(c, cl)
		cl.SetEntity(br)
	} else {
		cl.SetEntity(dr.GetSigningBlob())
	}
	dchan := make(chan string, 1)
	go func() {
		err := cl.SetDesignatedRouterSRVRecord(0, srv, dr)
		if err == nil {
			dchan <- "Designated router SRV record updated and confirmed"
		} else {
			dchan <- "Error updating SRV record: " + err.Error()
		}
	}()
	doChainOp(cl, dchan)
}

/*		{
			Name:   "mkalias",
			Usage:  "create an alias",
			Action: actionMkAlias,
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "long",
					Usage: "create a long alias with the given key",
					Value: "",
				},
				cli.StringFlag{
					Name:  "hex",
					Usage: "specify the content as a hex string",
					Value: "",
				},
				cli.StringFlag{
					Name:  "b64",
					Usage: "specify the content as urlsafe base64",
					Value: "",
				},
				cli.StringFlag{
					Name:  "text",
					Usage: "specify the content as UTF-8 text",
					Value: "",
				},
			},
		},
*/
func actionMkAlias(c *cli.Context) {
	//check usage
	if c.String("long") == "" {
		fmt.Println("You need to specify the alias text with --long")
		os.Exit(1)
	}
	key := []byte(c.String("long"))
	if len(key) > 32 {
		fmt.Println("Alias key cannot be longer than 32 bytes")
		os.Exit(1)
	}
	cl := bw2bind.ConnectOrExit("")
	b := getBankroll(c, cl)
	cl.SetEntityOrExit(b)
	binval := make([]byte, 32)
	set := false
	if c.String("hex") != "" {
		v, err := hex.DecodeString(c.String("hex"))
		if err != nil {
			fmt.Println("Could not decode hex argument:", err)
			os.Exit(1)
		}
		if len(v) > 32 {
			fmt.Println("Alias value cannot be greater than 32 bytes")
			os.Exit(1)
		}
		copy(binval, v)
		set = true
	}
	if c.String("text") != "" {
		tv := c.String("text")
		if set {
			fmt.Println("You cannot specify multiple values")
			os.Exit(1)
		}
		if len(tv) > 32 {
			fmt.Println("Alias value cannot be greater than 32 bytes")
			os.Exit(1)
		}
		copy(binval, []byte(tv))
		set = true
	}
	if c.String("b64") != "" {
		if set {
			fmt.Println("You cannot specify multiple values")
			os.Exit(1)
		}
		rv, err := base64.URLEncoding.DecodeString(c.String("b64"))
		if err != nil {
			fmt.Println("Could not decode b64:", err)
			os.Exit(1)
		}
		if len(rv) > 32 {
			fmt.Println("Alias value cannot be greater than 32 bytes")
			os.Exit(1)
		}
		copy(binval, rv)
		set = true
	}
	if !set {
		fmt.Println("You need to specify a value")
		os.Exit(1)
	}
	dchan := make(chan string, 1)
	go func() {
		err := cl.CreateLongAlias(0, key, binval)
		if err == nil {
			dchan <- "Alias record updated and confirmed"
		} else {
			dchan <- "Error creating alias: " + err.Error()
		}
	}()
	doChainOp(cl, dchan)

}
func actionMkDOT(c *cli.Context) {
	silencelog()
	cl := bw2bind.ConnectOrExit("")
	if !c.Bool("nopublish") {
		if c.String("bankroll") == "" {
			fmt.Println("Need bankroll to publish (or use --nopublish)")
			os.Exit(1)
		}
	}

	cl.SetEntityFileOrExit(c.String("from"))
	dur, err := util.ParseDuration(c.String("expiry"))
	if err != nil {
		fmt.Println("Could not parse expiry:", c.String("expiry"))
		os.Exit(1)
	}

	toVK, toOk := getEntityParamVK(cl, c, c.String("to"))
	if !toOk {
		fmt.Println("Could not parse 'to' parameter")
		os.Exit(1)
	}

	_, blob, err := cl.CreateDOT(&bw2bind.CreateDOTParams{
		IsPermission:      false,
		To:                toVK,
		TTL:               uint8(c.Int("ttl")),
		ExpiryDelta:       dur,
		Contact:           c.String("contact"),
		Comment:           c.String("comment"),
		Revokers:          c.StringSlice("revokers"),
		OmitCreationDate:  c.Bool("omitcreationdate"),
		URI:               c.String("uri"),
		AccessPermissions: c.String("permissions"),
	})
	if err != nil {
		fmt.Println("could not create dot:", err.Error())
		os.Exit(1)
	}
	doti, err := objects.NewDOT(objects.ROAccessDOT, blob)
	dot, ok := doti.(*objects.DOT)
	if err != nil || !ok {
		fmt.Println("Could not decode dot")
		os.Exit(1)
	}
	fmt.Println("DOT created")
	fmt.Println("Hash: ", crypto.FmtKey(dot.GetHash()))

	fname := c.String("outfile")
	if len(fname) == 0 {
		fname = "." + crypto.FmtKey(dot.GetHash()) + ".dot"
	}
	wrapped := make([]byte, len(dot.GetContent())+1)
	copy(wrapped[1:], dot.GetContent())
	wrapped[0] = objects.ROAccessDOT
	err = ioutil.WriteFile(fname, wrapped, 0666)
	if err != nil {
		fmt.Println("could not write dot to", fname, ":", err.Error())
		os.Exit(1)
	}
	fmt.Println("Wrote dot to file: ", fname)

	if !c.Bool("nopublish") {
		pubObj(dot, cl, c)
	}
}

func actionMkEntity(c *cli.Context) {
	silencelog()
	cl := bw2bind.ConnectOrExit("")
	if !c.Bool("nopublish") {
		if c.String("bankroll") == "" {
			fmt.Println("Need bankroll to publish (or use --nopublish)")
			os.Exit(1)
		}
	}
	dur, err := util.ParseDuration(c.String("expiry"))
	if err != nil {
		fmt.Println("Could not parse expiry:", c.String("expiry"))
		os.Exit(1)
	}
	_, blob, err := cl.CreateEntity(&bw2bind.CreateEntityParams{
		ExpiryDelta:      dur,
		Contact:          c.String("contact"),
		Comment:          c.String("comment"),
		Revokers:         c.StringSlice("revoker"),
		OmitCreationDate: c.Bool("omitcreationdate"),
	})
	if err != nil {
		fmt.Println("Could not create entity:", err.Error())
		os.Exit(1)
	}
	enti, err := objects.NewEntity(objects.ROEntityWKey, blob)
	if err != nil {
		panic(err)
	}
	ent := enti.(*objects.Entity)

	fmt.Println("Entity created")
	fmt.Println("Public  VK: ", crypto.FmtKey(ent.GetVK()))
	fmt.Println("Private SK: ", crypto.FmtKey(ent.GetSK()))

	fname := c.String("outfile")
	if len(fname) == 0 {
		fname = "." + crypto.FmtKey(ent.GetVK()) + ".key"
	}
	wrapped := make([]byte, len(ent.GetSigningBlob())+1)
	copy(wrapped[1:], ent.GetSigningBlob())
	wrapped[0] = objects.ROEntityWKey
	err = ioutil.WriteFile(fname, wrapped, 0600)
	if err != nil {
		fmt.Println("could not write entity to", fname, ":", err.Error())
		os.Exit(1)
	}
	fmt.Println("wrote key to file", fname)
	if !c.Bool("nopublish") {
		pubObj(ent, cl, c)
	}
}

func inspectInterface(ro objects.RoutingObject, cl *bw2bind.BW2Client) {
	switch ro.GetRONum() {
	case objects.ROEntity:
		e := ro.(*objects.Entity)
		if len(e.GetSK()) == 0 {
			fmt.Println("\u2533 Type: Entity (no key)")
		} else {
			fmt.Println("\u2533 Type: Entity key file")
		}
		doentityfile(ro.(*objects.Entity), cl)
	case objects.ROAccessDOT:
		fmt.Println("\u2533 Type: Access DOT")
		dodotfile(ro.(*objects.DOT), cl)
	case objects.ROPermissionDOT:
		fmt.Println("\u2533 Type: Application permission DOT")
		dodotfile(ro.(*objects.DOT), cl)
	case objects.ROPermissionDChain:
		fmt.Println("\u2533 Type: Permission DCHain")
		dochainfile(ro.(*objects.DChain), cl, true)
	case objects.ROPermissionDChainHash:
		fmt.Println("\u2533 Type: Permission DChain hash")
		dochainfile(ro.(*objects.DChain), cl, true)
	case objects.ROAccessDChain:
		fmt.Println("\u250f Type: Access DChain")
		dochainfile(ro.(*objects.DChain), cl, true)
	case objects.ROAccessDChainHash:
		fmt.Println("\u2533 Type: Access DChain hash")
		dochainfile(ro.(*objects.DChain), cl, true)
	default:
		fmt.Println("ERR: not a Routing Object file")
	}
	resetTerm()
}

func pubObj(topub objects.RoutingObject, cl *bw2bind.BW2Client, c *cli.Context) {
	pubObjs([]objects.RoutingObject{topub}, cl, c)
}
func pubObjs(topubz []objects.RoutingObject, cl *bw2bind.BW2Client, c *cli.Context) {
	cl.SetEntity(getBankroll(c, cl))
	dmsg := make(chan string, 1)
	wg := sync.WaitGroup{}
	wg.Add(len(topubz))
	problem := false
	go func() {
		wg.Wait()
		if problem {
			dmsg <- "Some objects failed to publish"
		} else {
			dmsg <- "All objects published"
		}
	}()

	fmt.Printf("Waiting for %d object(s) to publish\n", len(topubz))
	for _, vv := range topubz {
		go func(topub objects.RoutingObject) {
			var desc string
			var err error
			switch t := topub.(type) {
			case *objects.Entity:
				desc, err = cl.PublishEntity(t.GetContent())
				desc = "Entity " + desc
			case *objects.DOT:
				desc, err = cl.PublishDOT(t.GetContent())
				desc = "DOT " + desc
			case *objects.DChain:
				desc, err = cl.PublishChain(t.GetContent())
				desc = "DChain " + desc
			}
			if err == nil {
				fmt.Printf("\rSuccessfully published %s\n", desc)
			} else {
				problem = true
				fmt.Printf("\rFailed to publish object: %s\n", err.Error())
			}
			wg.Done()
		}(vv)
	}
	doChainOp(cl, dmsg)
}
func doChainOp(cl *bw2bind.BW2Client, done chan string) {
	cip, err := cl.GetBCInteractionParams()
	if err != nil {
		fmt.Printf("Could not get BCIP: %s\n", err)
		os.Exit(1)
	}
	//This is so we don't print the confirmation status for super short
	//things (already published etc)
	time.Sleep(500 * time.Millisecond)
	select {
	case m := <-done:
		fmt.Println(m)
		return
	default:
	}
	sblock := cip.CurrentBlock
	fmt.Printf("Current BCIP set to %d confirmation blocks or %d block timeout\n", cip.Confirmations, cip.Timeout)
	printChain := func() {
		fmt.Print("\rconfirming:")
		ncip, err := cl.GetBCInteractionParams()
		if err != nil {
			fmt.Printf("Could not get BCIP: %s\n", err)
			os.Exit(1)
		}
		for i := sblock; i < ncip.CurrentBlock; i++ {
			fmt.Printf("\U0001f517")
		}
		fmt.Printf(" (last block genesis was %d seconds ago)  ", ncip.CurrentAge/time.Second)
		os.Stdout.Sync()
	}
	for {
		select {
		case <-time.After(500 * time.Millisecond):
			printChain()
		case m := <-done:
			fmt.Println("\n" + m)
			return
		}
	}
}
func actionInspect(c *cli.Context) {
	cl := bw2bind.ConnectOrExit("")
	pub := c.Bool("publish")
	if pub {
		if c.String("bankroll") == "" {
			fmt.Println("Need bankroll to publish")
			os.Exit(1)
		}
	}
	topub := make([]objects.RoutingObject, 0)
	//TODO list:
	//if param is a file
	//	- recursively inspect every aspect of the object
	//if param is a 44 char b64 encoding, look it up as an object in the registry
	//with resx
	//if param contains a "@" expand it as embedded alias
	//expand it as a long alias
	for _, par := range c.Args() {
		//Try it as a file
		contents, err := ioutil.ReadFile(par)
		if err == nil {
			//We are a file
			roi, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Printf("'%s' exists as a file, but cannot be decoded: %s\n", par, err.Error())
				goto nextparam
			}
			inspectInterface(roi, cl)
			if pub {
				topub = append(topub, roi)
			}
			goto nextparam
		}
		//Look it up in the registry
		{
			roi, _, _ := cl.ResolveRegistry(par)
			//if status == bw2bind.StateError {
			//	fmt.Printf("'%s' does not exist as a file, trying the registry failed: %s\n", par, err.Error())
			//	goto nextparam
			//}
			if roi != nil {
				//fmt.Println("Match in registry:")
				inspectInterface(roi, cl)
				goto nextparam
			}
		}

		//We do not actually error out if it is not in the registry. Try resolve
		//it as some kind of alias
		if strings.Contains(par, "@") {
			res, err := cl.ResolveEmbeddedAlias(par)
			if err != nil {
				fmt.Printf("'%s' seemed like an embedded alias, but failed to resolve: %s\n", par, err.Error())
				goto nextparam
			}
			dstr := res
			if !utf8.ValidString(res) {
				dstr = "invalid (not UTF8)"
			}
			fmt.Printf("Embedded alias '%s' resolves to:\nhex: %032x\nstr: %s\nb64: %s\n", par, []byte(res), dstr, crypto.FmtHash([]byte(res)))
			goto nextparam
		} else {
			data, zero, err := cl.ResolveLongAlias(par)
			if err != nil {
				fmt.Printf("'%s' is not an existing file, published RO or long alias: %s\n", par, err.Error())
				goto nextparam
			}
			if zero {
				fmt.Printf("Could not resolve '%s' as file or alias\n", par)
				goto nextparam
			}
			dstr := string(data)
			if !utf8.Valid(data) {
				dstr = "invalid (not UTF8)"
			}
			fmt.Printf("Alias '%s' resolves to:\nhex: %032x\nstr: %s\nb64: %s\n", par, data, dstr, crypto.FmtHash(data))
			nz := false
			for i := 20; i < 32; i++ {
				if []byte(data)[i] != 0 {
					nz = true
					break
				}
			}
			if !nz {
				bal, err := cl.AddressBalance(fmt.Sprintf("%x", data[:20]))
				if err != nil {
					fmt.Println("Could not get balance:", err.Error())
				} else {
					f := big.NewFloat(0)
					f.SetInt(bal.Int)
					f = f.Quo(f, big.NewFloat(1000000000000000000.0))
					fmt.Printf("acc: 0x%040x balance %.6f \u039e\n", data[:20], f)
				}
			} else {
				fmt.Println("acc: invalid (trailing data)")
			}
			goto nextparam
		}

	nextparam:
	}
	//We need to re-set our entity because pprint modifies it to get balances
	if pub {
		pubObjs(topub, cl, c)
	}

}
func actionBuildChain(c *cli.Context) {
	silencelog()
	cl := bw2bind.ConnectOrExit("")
	if c.Bool("publish") {
		if c.String("bankroll") == "" {
			fmt.Println("Need bankroll to publish")
			os.Exit(1)
		}
	}

	toVK, toOk := getEntityParamVK(cl, c, c.String("to"))
	if !toOk {
		fmt.Println("Could not parse 'to' parameter")
		os.Exit(1)
	}

	uri := c.String("uri")
	if uri == "" {
		fmt.Println("Need a 'uri' parameter")
		os.Exit(1)
	}

	perms := c.String("permissions")
	if perms == "" {
		fmt.Println("Need permissions")
		os.Exit(1)
	}

	verbose := c.Bool("verbose")

	ch, err := cl.BuildChain(uri, perms, toVK)
	if err != nil {
		fmt.Println("DOT Chain build failed: ", err)
		os.Exit(1)
	}
	got := false
	topub := []objects.RoutingObject{}
	for res := range ch {
		got = true
		roi, err := objects.LoadRoutingObject(objects.ROAccessDChain, res.Content)
		if err != nil {
			panic(err)
		}
		dc := roi.(*objects.DChain)
		topub = append(topub, roi)
		dochainfile(dc, cl, verbose)
		resetTerm()
	}
	if !got {
		fmt.Println("No chains found")
		os.Exit(1)
	}
	if c.Bool("publish") {
		pubObjs(topub, cl, c)
	}
}
func actionXfer(c *cli.Context) {
	if c.String("bankroll") == "" {
		fmt.Println("Need bankroll to transfer from")
		os.Exit(1)
	}
	cl := bw2bind.ConnectOrExit("")
	cl.SetEntity(getBankroll(c, cl))
	eth := c.String("ether")
	milli := c.String("milli")
	micro := c.String("micro")
	total := big.NewFloat(0)
	total = total.SetPrec(256)
	toacc := getAccountParam(cl, c, c.String("to"))
	if eth != "" {
		incr, _, err := big.ParseFloat(eth, 10, 256, big.ToNearestEven)
		if err != nil {
			fmt.Println("Problem parsing --ether:", err)
			os.Exit(1)
		}
		incr.Mul(incr, big.NewFloat(1e18))
		total.Add(total, incr)
	}
	if milli != "" {
		incr, _, err := big.ParseFloat(milli, 10, 256, big.ToNearestEven)
		if err != nil {
			fmt.Println("Problem parsing --milli:", err)
			os.Exit(1)
		}
		incr.Mul(incr, big.NewFloat(1e15))
		total.Add(total, incr)
	}
	if micro != "" {
		incr, _, err := big.ParseFloat(micro, 10, 256, big.ToNearestEven)
		if err != nil {
			fmt.Println("Problem parsing --micro:", err)
			os.Exit(1)
		}
		incr.Mul(incr, big.NewFloat(1e12))
		total.Add(total, incr)
	}
	asEth := big.NewFloat(0)
	asEth = asEth.Quo(total, big.NewFloat(1000000000000000000.0))
	if total.Sign() == 0 {
		fmt.Println("You need to specify a nonzero amount to transfer")
		os.Exit(1)
	}
	wei, _ := total.Int(nil)
	dchan := make(chan string, 1)
	fmt.Printf("Transferring %.6f \u039ether\n  to: %s\n wei: %d\n", asEth, toacc, wei)
	go func() {
		err := cl.TransferWei(c.Int("accountnum"), toacc, wei)
		if err == nil {
			dchan <- "Transfer completed successfully"
		} else {
			dchan <- fmt.Sprintf("Transfer failed: %s", err)
		}
	}()
	doChainOp(cl, dchan)

}
func actionStatus(c *cli.Context) {
	cl := bw2bind.ConnectOrExit("")
	cip, err := cl.GetBCInteractionParams()
	if err != nil {
		fmt.Printf("Could not get BCIP: %s\n", err)
		os.Exit(1)
	}
	fmt.Println("BW2 Local Router status:")
	fmt.Printf("    Peer count: %d\n", cip.Peers)
	fmt.Printf(" Current block: %d\n", cip.CurrentBlock)
	fmt.Printf("    Seen block: %d\n", cip.HighestBlock)
	fmt.Printf("   Current age: %s\n", cip.CurrentAge.String())
	fmt.Printf("    Difficulty: %d\n", cip.Difficulty)
}

//sub -e entity uri uri uri
func actionSubscribe(c *cli.Context) {
	cl := bw2bind.ConnectOrExit("")
	if c.String("entity") == "" {
		fmt.Println("You need to specify an entity to be (-e)")
		os.Exit(1)
	}
	e := getAvailableEntity(c, c.String("entity"))
	if e == nil {
		fmt.Println("Could not load entity")
		os.Exit(1)
	}
	cl.SetEntity(e.GetSigningBlob())
	for _, uri := range c.Args() {
		ch := cl.SubscribeOrExit(&bw2bind.SubscribeParams{
			URI:       uri,
			AutoChain: true,
		})
		go func() {
			for m := range ch {
				m.Dump()
			}
		}()
	}
	for {
		time.Sleep(10 * time.Second)
	}
}

func actionQuery(c *cli.Context) {
	bw2bind.SilenceLog()
	cl := bw2bind.ConnectOrExit("")
	if c.String("entity") == "" {
		fmt.Println("You need to specify an entity to be (-e)")
		os.Exit(1)
	}
	e := getAvailableEntity(c, c.String("entity"))
	if e == nil {
		fmt.Println("Could not load entity")
		os.Exit(1)
	}
	cl.SetEntity(e.GetSigningBlob())
	cl.StatLine()
	for _, uri := range c.Args() {
		ch := cl.QueryOrExit(&bw2bind.QueryParams{
			URI:       uri,
			AutoChain: true,
		})
		go func() {
			for m := range ch {
				if m != nil {
					m.Dump()
				}
			}
		}()
	}
	for {
		time.Sleep(10 * time.Second)
	}
}

func actionMset(c *cli.Context) {
	bw2bind.SilenceLog()
	cl := bw2bind.ConnectOrExit("")
	if c.String("entity") == "" {
		fmt.Println("You need to specify an entity to be (-e)")
		os.Exit(1)
	}
	e := getAvailableEntity(c, c.String("entity"))
	if e == nil {
		fmt.Println("Could not load entity")
		os.Exit(1)
	}
	cl.SetEntity(e.GetSigningBlob())
	cl.StatLine()
	uri := c.String("uri")
	key := c.String("key")
	val := c.String("val")
	if key == "" || val == "" || uri == "" {
		fmt.Println("You must specify the uri, key and value")
		os.Exit(1)
	}
	err := cl.SetMetadata(uri, key, val)
	if err != nil {
		fmt.Println("Encountered error: ", err)
		os.Exit(1)
	} else {
		fmt.Println("Set OK")
		os.Exit(0)
	}
}

func actionMget(c *cli.Context) {
	bw2bind.SilenceLog()
	cl := bw2bind.ConnectOrExit("")
	if c.String("entity") == "" {
		fmt.Println("You need to specify an entity to be (-e)")
		os.Exit(1)
	}
	e := getAvailableEntity(c, c.String("entity"))
	if e == nil {
		fmt.Println("Could not load entity")
		os.Exit(1)
	}
	cl.SetEntity(e.GetSigningBlob())
	cl.StatLine()
	uri := c.String("uri")
	key := c.String("key")
	verb := c.Bool("verbose")
	if uri == "" {
		if len(c.Args()) == 0 {
			fmt.Println("You must specify the uri")
			os.Exit(1)
		}
		uri = c.Args()[0]
	}
	if key == "" {
		//All
		datmap, originmap, err := cl.GetMetadata(uri)
		if err != nil {
			fmt.Println("Encountered error: ", err)
			os.Exit(1)
		}
		maxl := 0
		for k, _ := range datmap {
			if len(k) > maxl {
				maxl = len(k)
			}
		}
		if maxl > 70 {
			maxl = 70
		}
		found := false
		for k, dat := range datmap {
			found = true
			fmt.Printf("%41s | %"+strconv.Itoa(maxl)+"s -> %s\n", dat.Time(), k, dat.Value)
			if verb {
				fmt.Printf("  inherited from %s\n", originmap[k])
			}
		}
		if !found {
			fmt.Println("There are no keys set for this URI")
		}
	} else {
		dat, origin, err := cl.GetMetadataKey(uri, key)
		if err != nil {
			fmt.Println("Encountered error: ", err)
			os.Exit(1)
		}
		if dat == nil {
			fmt.Printf("Key '%s' is not set\n", key)
		} else {
			fmt.Printf("%s -> %s @ %s\n", key, dat.Value, dat.Time())
			if verb {
				fmt.Printf("  inherited from %s\n", origin)
			}
		}
	}
}

func actionMdel(c *cli.Context) {
	bw2bind.SilenceLog()
	cl := bw2bind.ConnectOrExit("")
	if c.String("entity") == "" {
		fmt.Println("You need to specify an entity to be (-e)")
		os.Exit(1)
	}
	e := getAvailableEntity(c, c.String("entity"))
	if e == nil {
		fmt.Println("Could not load entity")
		os.Exit(1)
	}
	cl.SetEntity(e.GetSigningBlob())
	cl.StatLine()
	uri := c.String("uri")
	key := c.String("key")
	if key == "" || uri == "" {
		fmt.Println("You must specify the uri and the key")
		os.Exit(1)
	}
	err := cl.DelMetadata(uri, key)
	if err != nil {
		fmt.Println("Encountered error: ", err)
		os.Exit(1)
	} else {
		fmt.Println("Set OK")
		os.Exit(0)
	}
}

func actionDTrig(c *cli.Context) {
	cl := bw2bind.ConnectOrExit("")
	e := getAvailableEntity(c, "/home/immesys/.ssh/michael.key")
	if e == nil {
		fmt.Println("Could not load entity")
		os.Exit(1)
	}
	cl.SetEntity(e.GetSigningBlob())
	cl.StatLine()
	cl.DevelopTrigger()
}
