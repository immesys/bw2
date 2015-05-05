package main

import (
	"os"

	"github.com/codegangsta/cli"
)

//The version of BW2 this is
var BW2Version = "2.0.0 - 'Anarchy'"

func main() {
	app := cli.NewApp()
	app.Name = "bw2"
	app.Usage = "BossWave 2 universal tool. Run public or private routers, manage DoTs and DChains, and more"
	app.Version = BW2Version
	app.Commands = []cli.Command{
		{
			Name:  "router",
			Usage: "start a router as configured in the bw2.ini file",
			Action: func(c *cli.Context) {
				println("This hasn't been implemented yet")
			},
		},
		{
			Name:    "import",
			Aliases: []string{"i"},
			Usage:   "import DoTs, DChains or Entities from a bw2 keyring",
			Action: func(c *cli.Context) {
				println("This hasn't been implemented yet")
			},
		},
	}
	app.Run(os.Args)
}
