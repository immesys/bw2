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

package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"runtime"
	"path"
	"strings"
	"sync"
	"time"

	"github.com/codegangsta/cli"
	"github.com/immesys/bw2/adapter/oob"
	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/store"
	"github.com/immesys/bw2/internal/util"
	"github.com/immesys/bw2/objects"
	"github.com/mgutz/ansi"
	homedir "github.com/mitchellh/go-homedir"
)

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU())
	app := cli.NewApp()
	app.Name = "bw2"
	app.Usage = "BossWave 2 universal tool. Run public or private routers, manage DoTs and DChains, and more"
	app.Version = api.BW2Version
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:  "conf",
			Usage: "override the default config file",
		},
	}
	_ = cli.StringFlag{
		Name:   "entityfile, e",
		Usage:  "file containing the entity to perform the action as",
		EnvVar: "BW2_ENTITYFILE",
	}
	pflag := cli.StringSliceFlag{
		Name:  "publishto, p",
		Usage: "a router to publish created RO's to",
		Value: &cli.StringSlice{},
	}
	oflag := cli.StringFlag{
		Name:  "outfile, o",
		Usage: "save the result to this file",
	}
	app.Commands = []cli.Command{
		{
			Name:   "router",
			Usage:  "start a router as configured in the bw2.ini file",
			Action: actionRouter,
		},
		{
			Name:   "makeconf",
			Usage:  "create a new bw2.ini file",
			Action: makeConf,
		},
		{
			Name:    "mkentity",
			Aliases: []string{"mke"},
			Usage:   "create a new entity",
			Action:  actionMkEntity,
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "contact, c",
					Value: "",
					Usage: "contact attribute e.g. 'Oski Bear <oski@berkeley.edu>'",
				},
				cli.StringFlag{
					Name:  "comment, m",
					Value: "",
					Usage: "comment attribute e.g. 'Development Key'",
				},
				cli.StringSliceFlag{
					Name:  "revoker, r",
					Value: &cli.StringSlice{},
					Usage: "add a delegated revoker to this entity",
				},
				cli.DurationFlag{
					Name:  "expiry, e",
					Value: 30 * 24 * time.Hour,
					Usage: "set the expiry measured from now e.g. 300h",
				},
				cli.BoolFlag{
					Name:  "omitcreationdate",
					Usage: "don't add the creation date to the entity",
				},
				oflag, pflag,
			},
		},
		{
			Name:    "mkdot",
			Aliases: []string{"mkd"},
			Usage:   "create a new access dot",
			Action:  actionMkDOT,
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "contact, c",
					Value: "",
					Usage: "contact attribute e.g. 'Oski Bear <oski@berkeley.edu>'",
				},
				cli.StringFlag{
					Name:  "comment, m",
					Value: "",
					Usage: "comment attribute e.g. 'Development Key'",
				},
				cli.StringSliceFlag{
					Name:  "revoker, r",
					Value: &cli.StringSlice{},
					Usage: "add a delegated revoker to this entity",
				},
				cli.DurationFlag{
					Name:  "expiry, e",
					Value: 30 * 24 * time.Hour,
					Usage: "set the expiry measured from now e.g. 300h",
				},
				cli.BoolFlag{
					Name:  "omitcreationdate",
					Usage: "don't add the creation date to the entity",
				},
				cli.StringFlag{
					Name:  "permissions, x",
					Usage: "the access permissions string e.g PC*T*L",
					Value: "",
				},
				cli.StringFlag{
					Name:  "uri, u",
					Usage: "the URI to grant on",
					Value: "",
				},
				cli.StringFlag{
					Name:  "from, f",
					Usage: "the key file containing the From key",
					Value: "",
				},
				cli.StringFlag{
					Name:  "to, t",
					Usage: "the VK to grant to",
					Value: "",
				},
				cli.IntFlag{
					Name:  "ttl, l",
					Usage: "the TTL (number of hops) this DOT transfers",
					Value: 0,
				},
				oflag, pflag,
			},
		},
		{
			Name:    "inspect",
			Aliases: []string{"i"},
			Usage:   "inspect a file containing an Entity, DOT or DChain",
			Action:  actionInspect,
			Flags: []cli.Flag{
				pflag,
			},
		},
		{
			Name:    "buildchain",
			Aliases: []string{"bc"},
			Usage:   "build a DOT Chain",
			Action:  actionBuildChain,
			Flags: []cli.Flag{
				cli.StringSliceFlag{
					Name:  "router, r",
					Usage: "a router to query for DOTs (given as an MVK / DNS alias)",
					Value: &cli.StringSlice{},
				},
				cli.StringFlag{
					Name:  "uri, u",
					Usage: "the URI to build a chain for",
					Value: "",
				},
				cli.StringFlag{
					Name:  "permissions, x",
					Usage: "the permissions to try build",
					Value: "PCL",
				},
				cli.StringFlag{
					Name:  "to, t",
					Usage: "the VK to build a chain to",
					Value: "",
				},
				cli.BoolFlag{
					Name:  "verbose, v",
					Usage: "dump the verbose details of all chains",
				},
			},
		},
		{
			Name:    "resolve",
			Aliases: []string{"r"},
			Usage:   "resolve a hash or VK",
			Action:  actionResolve,
			Flags: []cli.Flag{
				cli.StringSliceFlag{
					Name:  "router, r",
					Usage: "a router to query for DOTs (given as an MVK / DNS alias)",
					Value: &cli.StringSlice{},
				},
				cli.StringFlag{
					Name:  "id, i",
					Usage: "the hash or VK to resolve",
					Value: "",
				},
				cli.BoolFlag{
					Name:  "extended, x",
					Usage: "recursively resolve objects referenced by the primary",
				},
				cli.StringFlag{
					Name:  "uri, u",
					Usage: "A URI or DNS alias",
					Value: "",
				},
				oflag, pflag,
			},
		},
	}
	app.Run(os.Args)
}

func actionRouter(c *cli.Context) {
	cfg := c.String("conf")
	var config *core.BWConfig
	if len(cfg) != 0 {
		config = core.LoadConfig(cfg)
	}
	bw := api.OpenBWContext(config)
	oob := new(oob.Adapter)
	fmt.Println("router starting")
	go api.Start(bw)
	oob.Start(bw)
}

func getTempBW(c *cli.Context) *api.BW {
	scfg := c.GlobalString("conf")
	var cfg *core.BWConfig
	if len(scfg) != 0 {
		cfg = core.LoadConfig(scfg)
	} else {
		hm, err := homedir.Dir()
		if err != nil {
			panic(err)
		}
		dbpath := path.Join(hm, ".bw.cli.db")
		cfg = &core.BWConfig{}
		cfg.Router.DB = dbpath
		//router keys are irrelevant, save generation entropy by hardcoding
		cfg.Router.SK = "NmSf-XwX0rtbaIVUhnxMoL_pBkRdUWyfX6nf4zpR8Rk="
		cfg.Router.VK = "g_DLjUQ-16JECSuMGMe779RpAuEgsNC5W8c7siGEAME="
	}
	rv := api.OpenBWContext(cfg)
	return rv
}
func doExit(bw *api.BW, code int, msg string) {
	if msg != "" {
		fmt.Println(msg)
	}
	os.Exit(code)
}
func publishROs(cl *api.BosswaveClient, target string, ros []objects.RoutingObject) {
	mvk, err := cl.BW().ResolveName(target)
	if err != nil {
		doExit(cl.BW(), 1, "could not resolve target to designated router")
	}
	cnt := make(chan bool)
	go cl.Publish(&api.PublishParams{
		MVK:            mvk,
		URISuffix:      "null",
		RoutingObjects: ros,
	},
		func(code int, status string) {
			if code != 405 {
				fmt.Printf("got unexpected response from peer pub %d : %s\n", code, status)
			}
			cnt <- true
		})
	_ = <-cnt

}
func getRandomEntity(cl *api.BosswaveClient) *objects.Entity {
	dur := 10 * time.Minute
	ent := cl.CreateEntity(&api.CreateEntityParams{
		ExpiryDelta: &dur,
		Contact:     "ephemeral",
		Comment:     "ephemeral",
	})
	return ent
}
func actionMkEntity(c *cli.Context) {
	bw := getTempBW(c)
	cl := bw.CreateClient()
	srevokers := c.StringSlice("revokers")
	revokers := make([][]byte, len(srevokers))
	for i, rvk := range srevokers {
		var err error
		revokers[i], err = crypto.UnFmtKey(rvk)
		if err != nil {
			doExit(bw, 1, "could not parse revoker key")
		}
	}
	dur := c.Duration("expiry")
	ent := cl.CreateEntity(&api.CreateEntityParams{
		ExpiryDelta:      &dur,
		Contact:          c.String("contact"),
		Comment:          c.String("comment"),
		Revokers:         revokers,
		OmitCreationDate: c.Bool("omitcreation"),
	})
	if ent == nil {
		doExit(bw, 1, "could not create entity")
	}
	cl.SetEntityObj(ent)
	for _, tgt := range c.StringSlice("publishto") {
		publishROs(cl, tgt, []objects.RoutingObject{ent})
	}
	lname := scanLocal(c, cl)
	if lname != nil {
		publishROs(cl, *lname, []objects.RoutingObject{ent})
	}
	fmt.Println("Entity created")
	fmt.Println("SK: ", crypto.FmtKey(ent.GetSK()))
	fmt.Println("VK: ", crypto.FmtKey(ent.GetVK()))

	fname := c.String("outfile")
	if len(fname) == 0 {
		fname = "." + crypto.FmtKey(ent.GetVK()) + ".key"
	}
	wrapped := make([]byte, len(ent.GetSigningBlob())+1)
	copy(wrapped[1:], ent.GetSigningBlob())
	wrapped[0] = objects.ROEntityWKey
	err := ioutil.WriteFile(fname, wrapped, 0600)
	if err != nil {
		doExit(bw, 1, "could not write key to: "+fname)
	}
	fmt.Println("Wrote key to file: ", fname)
	doExit(bw, 0, "")
}
func actionMkDOT(c *cli.Context) {
	bw := getTempBW(c)
	cl := bw.CreateClient()
	if len(c.String("from")) == 0 {
		doExit(bw, 1, "could not load FROM keyfile")
	}
	wkeyblob, err := ioutil.ReadFile(c.String("from"))
	if err != nil {
		doExit(bw, 1, err.Error())
	}
	if wkeyblob[0] != objects.ROEntityWKey {
		doExit(bw, 1, "from file is not a keyfile")
	}
	cl.SetEntity(&api.SetEntityParams{
		Keyfile: wkeyblob[1:],
	})
	if len(c.String("to")) == 0 {
		doExit(bw, 1, "missing TO param")
	}
	tovk, err := crypto.UnFmtKey(c.String("to"))
	if err != nil {
		doExit(bw, 1, err.Error())
	}
	if len(c.String("permissions")) == 0 {
		doExit(bw, 1, "missing permission string")
	}
	srevokers := c.StringSlice("revokers")
	revokers := make([][]byte, len(srevokers))
	for i, rvk := range srevokers {
		var err error
		revokers[i], err = crypto.UnFmtKey(rvk)
		if err != nil {
			doExit(bw, 1, "could not parse revoker key")
		}
	}
	ttl := c.Int("ttl")
	if ttl < 0 || ttl > 255 {
		doExit(bw, 1, "TTL must be in [0, 255]")
	}
	uri := c.String("uri")
	parts := strings.SplitN(uri, "/", 2)
	if len(parts) != 2 {
		doExit(bw, 1, "invalid URI")
	}
	mvk, err := crypto.UnFmtKey(parts[0])
	uriSuffix := parts[1]
	if err != nil {
		possibleMVK, err := bw.ResolveName(parts[0])
		if err == nil {
			fmt.Printf("NOTE, resolved DNS aliased URI to :%s\n", crypto.FmtKey(possibleMVK)+"/"+parts[1])
			mvk = possibleMVK
		} else {
			doExit(bw, 1, "could not parse the MVK in the URI")
		}
	}
	valid, _, _, _, _ := util.AnalyzeSuffix(uriSuffix)
	if !valid {
		doExit(bw, 1, "This URI is invalid")
	}
	edelta := c.Duration("expiry")
	dot := cl.CreateDOT(&api.CreateDOTParams{
		To:                tovk,
		TTL:               uint8(ttl),
		ExpiryDelta:       &edelta,
		Contact:           c.String("contact"),
		Comment:           c.String("comment"),
		Revokers:          revokers,
		OmitCreationDate:  c.Bool("omitcreationdate"),
		URISuffix:         uriSuffix,
		MVK:               mvk,
		AccessPermissions: c.String("permissions"),
	})
	if dot == nil {
		doExit(bw, 1, "failed to create DOT")
	}
	for _, tgt := range c.StringSlice("publishto") {
		publishROs(cl, tgt, []objects.RoutingObject{dot})
	}
	lname := scanLocal(c, cl)
	if lname != nil {
		publishROs(cl, *lname, []objects.RoutingObject{dot})
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
		doExit(bw, 1, "could not write dot to: "+fname)
	}
	fmt.Println("Wrote dot to file: ", fname)
	doExit(cl.BW(), 0, "")
}

func distEntity(e *objects.Entity, cl *api.BosswaveClient, to []string) {
	core.DistributeRO(cl.BW().Entity, e, cl.CL())
	for _, tgt := range to {
		publishROs(cl, tgt, []objects.RoutingObject{e})
	}
}
func distDOT(d *objects.DOT, cl *api.BosswaveClient, to []string) {
	core.DistributeRO(cl.BW().Entity, d, cl.CL())
	for _, tgt := range to {
		publishROs(cl, tgt, []objects.RoutingObject{d})
	}
	fe, ok := store.GetEntity(d.GetGiverVK())
	if ok {
		distEntity(fe, cl, to)
	}
	fe, ok = store.GetEntity(d.GetReceiverVK())
	if ok {
		distEntity(fe, cl, to)
	}
}
func distChain(c *objects.DChain, cl *api.BosswaveClient, to []string) {
	if !c.IsElaborated() {
		fmt.Printf("Chain is not elaborated?")
		return
	}
	core.DistributeRO(cl.BW().Entity, c, cl.CL())
	for _, tgt := range to {
		publishROs(cl, tgt, []objects.RoutingObject{c})
	}
	for i := 0; i < c.NumHashes(); i++ {
		dt, ok := store.GetDOT(c.GetDotHash(i))
		if ok {
			distDOT(dt, cl, to)
		}
	}
}
func scanLocal(ctx *cli.Context, cl *api.BosswaveClient) *string {
	if ctx.Bool("skiplocal") {
		return nil
	}
	peer, err := cl.GetPeerByTrustedTarget("127.0.0.1:4514")
	if err != nil {
		fmt.Println("WARN: could not connect to local router")
		return nil
	}
	name := cl.InjectPeer(peer)
	return &name
}
func actionInspect(c *cli.Context) {
	bw := getTempBW(c)
	cl := bw.CreateClient()
	rent := getRandomEntity(cl)
	cl.SetEntityObj(rent)

	lname := scanLocal(c, cl)
	resolvers := c.StringSlice("router")
	if lname != nil {
		resolvers = append(resolvers, *lname)
	}
	pubto := c.StringSlice("publishto")
	if lname != nil {
		pubto = append(pubto, *lname)
	}
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
			distEntity(ro.(*objects.Entity), cl, pubto)
			doentity(ro.(*objects.Entity), 2)
		case objects.ROEntityWKey:
			fmt.Println("\u2533 Type: Entity key file")
			ro, err := objects.LoadRoutingObject(objects.ROEntity, contents[33:])
			if err != nil {
				fmt.Println("ERR: could not parse: " + err.Error())
				return
			}
			ent := ro.(*objects.Entity)
			distEntity(ent, cl, pubto)
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
			distDOT(dot, cl, pubto)
			dodot(dot, 2, cl, resolvers)
		case objects.ROPermissionDOT:
			fmt.Println("\u2533 Type: Application permission DOT")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse: " + err.Error())
				return
			}
			dot := ro.(*objects.DOT)
			distDOT(dot, cl, pubto)
			dodot(dot, 2, cl, resolvers)
		case objects.ROPermissionDChain:
			fmt.Println("\u2533 Type: Permission DCHain")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse")
				return
			}
			dc := ro.(*objects.DChain)
			distChain(dc, cl, pubto)
			dochain(dc, 2, true, cl, resolvers)
		case objects.ROPermissionDChainHash:
			fmt.Println("\u2533 Type: Permission DChain hash")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse")
				return
			}
			dc := ro.(*objects.DChain)
			distChain(dc, cl, pubto)
			dochain(dc, 2, true, cl, resolvers)
		case objects.ROAccessDChain:
			fmt.Println("\u250f Type: Access DChain")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse")
				return
			}
			dc := ro.(*objects.DChain)
			distChain(dc, cl, pubto)
			dochain(dc, 2, true, cl, resolvers)
		case objects.ROAccessDChainHash:
			fmt.Println("\u2533 Type: Access DChain hash")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse")
				return
			}
			dc := ro.(*objects.DChain)
			distChain(dc, cl, pubto)
			dochain(dc, 2, true, cl, resolvers)
		default:
			fmt.Println("ERR: not a Routing Object file")
		}
	}
	fmt.Print(ansi.ColorCode("reset"))
}
func actionBuildChain(c *cli.Context) {
	bw := getTempBW(c)
	cl := bw.CreateClient()
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
	cb := api.NewChainBuilder(cl, uri, perms, target, status)
	//Add the CLI router as a peer so we use its database
	cb.AddPeerMVK(bw.Entity.GetVK())
	uriparts := strings.SplitN(uri, "/", 2)
	if len(uriparts) != 2 {
		doExit(bw, 1, "Malformed URI")
	}
	urimvk, err := bw.ResolveName(uriparts[0])
	if err != nil {
		doExit(bw, 1, "Could not resolve URI MVK")
	}
	cb.AddPeerMVK(urimvk)
	fmt.Println("bw.Ent: ", crypto.FmtKey(bw.Entity.GetVK()))
	for _, sp := range c.StringSlice("router") {
		mvk, err := bw.ResolveName(sp)
		if err != nil {
			doExit(bw, 1, "Could not resolve router: "+err.Error())
		}
		cb.AddPeerMVK(mvk)
	}
	lname := scanLocal(c, cl)
	resolvers := c.StringSlice("router")
	if lname != nil {
		resolvers = append(resolvers, *lname)
	}
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
	cl := bw.CreateClient()
	rent := getRandomEntity(cl)
	cl.SetEntityObj(rent)
	lname := scanLocal(c, cl)
	resolvers := c.StringSlice("router")
	if lname != nil {
		resolvers = append(resolvers, *lname)
	}
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
		if lname != nil {
			ask = append(ask, *lname)
		}
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
		mvk, err := bw.ResolveName(parts[0])
		if err != nil {
			doExit(bw, 1, "cannot resolve uri")
		}
		smvk := crypto.FmtKey(mvk)
		fmt.Println("URI MVK is  : ", smvk)
		drvk, err := bw.GetDRVK(smvk)
		if err != nil {
			fmt.Println("WARN: cannot get designated router VK for uri")
			doExit(bw, 0, "")
		}
		fmt.Println("URI DRVK is : ", crypto.FmtKey(drvk))
		tgt, err := bw.GetTarget(crypto.FmtKey(drvk))
		if err != nil {
			fmt.Println("WARN: cannot get target for DRVK")
			doExit(bw, 0, "")
		}
		fmt.Println("DRVK target : ", tgt)
		doExit(bw, 0, "")
	}

}

/*
func actionMkEntity(c *cli.Context) {
	if !c.IsSet("output") {
		fmt.Println("you need to specify the output file")
		os.Exit(-1)
	}
	if !c.IsSet("expiry") {
		fmt.Println("warning: using default expiry of 1 month")
	}
	var revokers [][]byte
	rparam := c.StringSlice("revoker")
	if rparam != nil {
		for _, v := range rparam {
			key, err := crypto.UnFmtKey(v)
			if err != nil {
				fmt.Printf("Bad delegated revoker key: '%s'\n", v)
				os.Exit(-1)
			}
			revokers = append(revokers, key)
		}
	}
	entity, err := api.CreateNewSigningKeyFile(c.String("output"), c.String("contact"),
		c.String("comment"), revokers, c.Duration("expiry"))
	if err != nil {
		fmt.Printf("An error occured: %v\n", err)
		os.Exit(-1)
	}
	fmt.Println("Created:")
	fmt.Println(entity.FullString())
}
*/
