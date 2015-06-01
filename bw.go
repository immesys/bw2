package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
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
)

func main() {
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
		/*
			type CreateDOTParams struct {
				IsPermission     bool
				To               []byte
				TTL              uint8
				Expiry           *time.Time
				ExpiryDelta      *time.Duration
				Contact          string
				Comment          string
				Revokers         [][]byte
				OmitCreationDate bool

				//For Access
				URISuffix         string
				MVK               []byte
				AccessPermissions string

				//For Permissions
				Permissions map[string]string
			}
		*/
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
		/*
			{
				Name:    "import",
				Aliases: []string{"i"},
				Usage:   "import DoTs, DChains or Entities from a bw2 keyring",
				Action: func(c *cli.Context) {
					println("This hasn't been implemented yet")
				},
			},
			{
				Name:    "mkentity",
				Aliases: []string{"mke"},
				Usage:   "create a new entity and save it to a file",
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
					cli.StringFlag{
						Name:  "output, o",
						Value: "",
						Usage: "output file to write to",
					},
				},
				Action: actionMkEntity,
			},*/
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
		dbpath, err := ioutil.TempDir("", "bw2cli")
		if err != nil {
			fmt.Println("ERROR: could not create CLI temporary database: ", err.Error())
			os.Exit(1)
		}
		cfg := &core.BWConfig{}
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
			fmt.Printf("got response %d : %s\n", code, status)
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
	fmt.Println("Entity created")
	fmt.Println("SK: ", crypto.FmtKey(ent.GetSK()))
	fmt.Println("VK: ", crypto.FmtKey(ent.GetVK()))

	fname := c.String("outfile")
	if len(fname) == 0 {
		fname = "bw2." + crypto.FmtKey(ent.GetVK()) + ".key"
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
			fmt.Println("You cannot use a DNS alias for the MVK in a DOT URI for security reasons")
			fmt.Printf("check this URI is correct and then specify it explicitly:\n%s\n", crypto.FmtKey(possibleMVK)+"/"+parts[1])
			doExit(bw, 1, "")
		} else {
			fmt.Println("could not parse the MVK in the URI")
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
	fmt.Println("DOT created")
	fmt.Println("Hash: ", crypto.FmtKey(dot.GetHash()))

	fname := c.String("outfile")
	if len(fname) == 0 {
		fname = "bw2." + crypto.FmtKey(dot.GetHash()) + ".dot"
	}
	wrapped := make([]byte, len(dot.GetContent())+1)
	copy(wrapped[1:], dot.GetContent())
	wrapped[0] = objects.ROAccessDOT
	err = ioutil.WriteFile(fname, wrapped, 0600)
	if err != nil {
		doExit(bw, 1, "could not write dot to: "+fname)
	}
	fmt.Println("Wrote dot to file: ", fname)
	doExit(cl.BW(), 0, "")
}
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
	return rv + codes[level-2] + "\u2523" + codes[level-1] + "\u2533"
}
func actionInspect(c *cli.Context) {
	bw := getTempBW(c)
	cl := bw.CreateClient()

	doentity := func(e *objects.Entity, indent int) {
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
	dodot := func(d *objects.DOT, indent int) {
		fmt.Println(ifstring(indent) + " DOT " + crypto.FmtHash(d.GetHash()))
		if d.SigValid() {
			fmt.Println(istring(indent) + " Signature valid")
		} else {
			fmt.Println(istring(indent) + " Signature INVALID")
		}
		fmt.Println(istring(indent) + " From: " + crypto.FmtKey(d.GetGiverVK()))
		fe, ok := store.GetEntity(d.GetGiverVK())
		if ok {
			doentity(fe, indent+1)
		} else {
			fmt.Println(ifstring(indent+1) + " Unknown Entity")
		}
		fmt.Println(istring(indent) + " To: " + crypto.FmtKey(d.GetGiverVK()))
		fe, ok = store.GetEntity(d.GetReceiverVK())
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
	dochain := func(contents []byte, indent int) {
		ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
		if err != nil {
			fmt.Println("ERR: could not parse")
			return
		}
		dc := ro.(*objects.DChain)
		fmt.Println(ifstring(indent)+" DChain ", crypto.FmtHash(dc.GetChainHash()))
		if !dc.IsElaborated() {
			fmt.Println(istring(indent) + " Elaborated: False")
		} else {
			fmt.Println(istring(indent) + " Elaborated: True")
			for i := 0; i < dc.NumHashes(); i++ {
				dh := dc.GetDotHash(i)
				fmt.Printf(istring(indent)+" DOT[%d] = %s\n", i, crypto.FmtHash(dh))
				dt, ok := store.GetDOT(dh)
				if ok {
					dodot(dt, indent+1)
				} else {
					fmt.Println(ifstring(indent+1) + " DOT is not resolvable")
				}
			}
		}
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
			core.DistributeRO(bw.Entity, ro, cl.CL())
			doentity(ro.(*objects.Entity), 1)
		case objects.ROEntityWKey:
			fmt.Println("\u2533 Type: Entity key file")
			ro, err := objects.LoadRoutingObject(objects.ROEntity, contents[33:])
			if err != nil {
				fmt.Println("ERR: could not parse: " + err.Error())
				return
			}
			core.DistributeRO(bw.Entity, ro, cl.CL())
			ent := ro.(*objects.Entity)
			ent.SetSK(contents[1:33])
			doentity(ro.(*objects.Entity), 1)
		case objects.ROAccessDOT:
			fmt.Println("\u2533 Type: Access DOT")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse: " + err.Error())
				return
			}
			core.DistributeRO(bw.Entity, ro, cl.CL())
			dot := ro.(*objects.DOT)
			dodot(dot, 2)
		case objects.ROPermissionDOT:
			fmt.Println("\u2533 Type: Application permission DOT")
			ro, err := objects.LoadRoutingObject(int(contents[0]), contents[1:])
			if err != nil {
				fmt.Println("ERR: could not parse: " + err.Error())
				return
			}
			core.DistributeRO(bw.Entity, ro, cl.CL())
			dot := ro.(*objects.DOT)
			dodot(dot, 1)
		case objects.ROPermissionDChain:
			fmt.Println("\u2533 Type: Permission DCHain")
			dochain(contents, 1)
		case objects.ROPermissionDChainHash:
			fmt.Println("\u2533 Type: Permission DChain hash")
			dochain(contents, 1)
		case objects.ROAccessDChain:
			fmt.Println("\u250f Type: Access DChain")
			dochain(contents, 1)
		case objects.ROAccessDChainHash:
			fmt.Println("\u2533 Type: Access DChain hash")
			dochain(contents, 1)
		default:
			fmt.Println("ERR: not a Routing Object file")
		}
	}
	fmt.Print(ansi.ColorCode("reset"))
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
