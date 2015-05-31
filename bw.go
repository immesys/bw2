package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"time"

	"github.com/codegangsta/cli"
	"github.com/immesys/bw2/adapter/oob"
	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/objects"
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
				oflag, pflag,
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
	fmt.Println("conf param: ", scfg)
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
	cl.SetEntity(&api.SetEntityParams{
		Keyfile: ent.GetSigningBlob(),
	})
	for _, tgt := range c.StringSlice("publishto") {
		publishROs(cl, tgt, []objects.RoutingObject{ent})
	}
	fmt.Println("Entity created")
	fmt.Println("SK: ", crypto.FmtKey(ent.GetSK()))
	fmt.Println("VK: ", crypto.FmtKey(ent.GetVK()))
	fmt.Println()
	doExit(cl.BW(), 0, "")
}
func actionMkDOT(c *cli.Context) {
	bw := getTempBW(c)
	cl := bw.CreateClient()
	if len(c.String("from")) == 0 {
		doExit(bw, 1, "could not load FROM keyfile")
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
