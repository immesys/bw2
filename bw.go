package main

import (
	"fmt"
	"os"

	"github.com/codegangsta/cli"
	"github.com/immesys/bw2/adapter/oob"
	"github.com/immesys/bw2/api"
)

func main() {
	app := cli.NewApp()
	app.Name = "bw2"
	app.Usage = "BossWave 2 universal tool. Run public or private routers, manage DoTs and DChains, and more"
	app.Version = api.BW2Version
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
	bw := api.OpenBWContext(nil)
	oob := new(oob.Adapter)
	fmt.Println("router starting")
	go api.Start(bw)
	oob.Start(bw)
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
