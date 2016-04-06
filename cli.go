//+build ignore

package main

import (
	"fmt"
	"io/ioutil"
	"strings"
	"sync"

	"github.com/codegangsta/cli"
	"github.com/immesys/bw2/api"
	_ "github.com/immesys/bw2/bw2bind"
	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/mgutz/ansi"
)

func actionInspect(c *cli.Context) {
	bw := getTempBW(c)
	cl := bw.CreateClient("cli")
	rent := getRandomEntity(cl)
	cl.SetEntityObj(rent)
	resolvers := c.StringSlice("router")
	//XTAG cli changes
	/*
			lname := scanLocal(c, cl)

			if lname != nil {
				resolvers = append(resolvers, *lname)
			}

		pubto := c.StringSlice("publishto")
		if lname != nil {
			pubto = append(pubto, *lname)
		}
	*/
	for _, fl := range c.Args() {
		fmt.Println("Inspecting: ", fl, ansi.ColorCode("reset"))
		contents, err := ioutil.ReadFile(fl)
		if err != nil {
			doExit(bw, 1, "Reading "+fl+": "+err.Error())
		}
		switch contents[0] {
		case objects.ROEntity:
			fmt.Println("\u2533 Type: Entity (no key)")
			ro, err := objects.LoadRoutingObject(objects.ROEntity, contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse: " + err.Error())
				return
			}
			//distEntity(ro.(*objects.Entity), cl, pubto)
			doentity(ro.(*objects.Entity), 2)
		case objects.ROEntityWKey:
			fmt.Println("\u2533 Type: Entity key file")
			ro, err := objects.LoadRoutingObject(objects.ROEntity, contents[33:])
			if err != nil {
				fmt.Println("ERR: could not parse: " + err.Error())
				return
			}
			ent := ro.(*objects.Entity)
			//distEntity(ent, cl, pubto)
			ent.SetSK(contents[1:33])
			doentity(ro.(*objects.Entity), 2)
		case objects.ROAccessDOT:
			fmt.Println("\u2533 Type: Access DOT")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse: " + err.Error())
				return
			}
			dot := ro.(*objects.DOT)
			//distDOT(dot, cl, pubto)
			dodot(dot, 2, cl, resolvers)
		case objects.ROPermissionDOT:
			fmt.Println("\u2533 Type: Application permission DOT")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse: " + err.Error())
				return
			}
			dot := ro.(*objects.DOT)
			//distDOT(dot, cl, pubto)
			dodot(dot, 2, cl, resolvers)
		case objects.ROPermissionDChain:
			fmt.Println("\u2533 Type: Permission DCHain")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse")
				return
			}
			dc := ro.(*objects.DChain)
			//distChain(dc, cl, pubto)
			dochain(dc, 2, true, cl, resolvers)
		case objects.ROPermissionDChainHash:
			fmt.Println("\u2533 Type: Permission DChain hash")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse")
				return
			}
			dc := ro.(*objects.DChain)
			//distChain(dc, cl, pubto)
			dochain(dc, 2, true, cl, resolvers)
		case objects.ROAccessDChain:
			fmt.Println("\u250f Type: Access DChain")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse")
				return
			}
			dc := ro.(*objects.DChain)
			//distChain(dc, cl, pubto)
			dochain(dc, 2, true, cl, resolvers)
		case objects.ROAccessDChainHash:
			fmt.Println("\u2533 Type: Access DChain hash")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse")
				return
			}
			dc := ro.(*objects.DChain)
			//distChain(dc, cl, pubto)
			dochain(dc, 2, true, cl, resolvers)
		default:
			fmt.Println("ERR: not a Routing Object file")
		}
	}
	fmt.Print(ansi.ColorCode("reset"))
}
func actionBuildChain(c *cli.Context) {
	bw := getTempBW(c)
	cl := bw.CreateClient("cli")
	rent := getRandomEntity(cl)
	fmt.Println("RENT VK:", crypto.FmtKey(rent.GetVK()))
	cl.SetEntityObj(rent)
	uri := c.String("uri")
	perms := c.String("permissions")
	target, err := crypto.UnFmtKey(c.String("to"))
	if err != nil {
		doExit(bw, 1, "Invalid 'to' key")
	}
	status := make(chan string, 10)
	outwg := sync.WaitGroup{}
	outwg.Add(1)
	go func() {
		for s := range status {
			fmt.Println("CB: ", s)
		}
		outwg.Done()
	}()
	uriparts := strings.SplitN(uri, "/", 2)
	if len(uriparts) != 2 {
		doExit(bw, 1, "Malformed URI")
	}
	urimvk, err := bw.ResolveNamespace(uriparts[0])
	if err != nil {
		doExit(bw, 1, "Could not resolve URI MVK")
	}
	cb := api.NewChainBuilder(cl, crypto.FmtKey(urimvk)+"/"+uriparts[1], perms, target, status)
	//Add the CLI router as a peer so we use its database
	cb.AddPeerMVK(bw.Entity.GetVK())
	cb.AddPeerMVK(urimvk)
	fmt.Println("bw.Ent: ", crypto.FmtKey(bw.Entity.GetVK()))
	for _, sp := range c.StringSlice("router") {
		mvk, err := bw.ResolveNamespace(sp)
		if err != nil {
			doExit(bw, 1, "Could not resolve router: "+err.Error())
		}
		cb.AddPeerMVK(mvk)
	}
	resolvers := c.StringSlice("router")
	//XTAG cli changes
	/*
		lname := scanLocal(c, cl)

		if lname != nil {
			resolvers = append(resolvers, *lname)
		}
	*/
	chains, err := cb.Build()
	if err != nil {
		doExit(bw, 1, "Builder error: "+err.Error())
	}
	fmt.Println("Complete")
	for _, dc := range chains {
		fmt.Print(ansi.ColorCode("reset"))
		fmt.Println("found chain: ", crypto.FmtHash(dc.GetChainHash()))
		dochain(dc, 2, c.Bool("verbose"), cl, resolvers)
		fmt.Print(ansi.ColorCode("reset"))
	}
	for _, dc := range chains {
		wrapped := make([]byte, len(dc.GetContent())+1)
		copy(wrapped[1:], dc.GetContent())
		wrapped[0] = byte(dc.GetRONum())
		fname := fmt.Sprintf(".%s.chain", crypto.FmtHash(dc.GetChainHash()))
		err = ioutil.WriteFile(fname, wrapped, 0666)
		if err != nil {
			doExit(bw, 1, "could not write dchain to: "+fname)
		}
		fmt.Println("Wrote chain to file: ", fname)
	}
	outwg.Wait()
}

func actionResolve(c *cli.Context) {
	bw := getTempBW(c)
	cl := bw.CreateClient("cli")
	rent := getRandomEntity(cl)
	cl.SetEntityObj(rent)
	resolvers := c.StringSlice("router")
	/*
		lname := scanLocal(c, cl)
		if lname != nil {
			resolvers = append(resolvers, *lname)
		}
	*/
	id := c.String("id")
	uri := c.String("uri")
	if len(id) == 0 && len(uri) == 0 ||
		len(id) != 0 && len(uri) != 0 {
		doExit(bw, 1, "must have either URI or ID")
	}
	if len(id) != 0 {
		if len(id) != 44 {
			doExit(bw, 1, "id is malformed")
		}
		ask := c.StringSlice("router")
		/*
			if lname != nil {
				ask = append(ask, *lname)
			}
		*/
		obj := cl.Resolve(id, ask)
		if obj == nil {
			doExit(bw, 0, "Could not resolve that ID")
		}
		switch obj.(type) {
		case *objects.DOT:
			dodot(obj.(*objects.DOT), 2, cl, resolvers)
		case *objects.DChain:
			dochain(obj.(*objects.DChain), 2, true, cl, resolvers)
		case *objects.Entity:
			doentity(obj.(*objects.Entity), 2)
		}
		fmt.Print(ansi.ColorCode("reset"))
		doExit(bw, 0, "")
	} else {
		parts := strings.SplitN(uri, "/", 2)
		mvk, err := bw.ResolveNamespace(parts[0])
		if err != nil {
			doExit(bw, 1, "cannot resolve uri")
		}
		smvk := crypto.FmtKey(mvk)
		fmt.Println("URI MVK is  : ", smvk)
		drvk, err := bw.LookupDesignatedRouter(mvk)
		if err != nil {
			fmt.Println("WARN: cannot get designated router VK for uri")
			doExit(bw, 0, "")
		}
		fmt.Println("URI DRVK is : ", crypto.FmtKey(drvk))
		tgt, err := bw.LookupDesignatedRouterSRV(drvk)
		if err != nil {
			fmt.Println("WARN: cannot get target for DRVK")
			doExit(bw, 0, "")
		}
		fmt.Println("DRVK target : ", tgt)
		doExit(bw, 0, "")
	}

}
