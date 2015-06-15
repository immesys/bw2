package main

import (
	"fmt"
	"os"

	"github.com/codegangsta/cli"
	"github.com/immesys/bw2/adapter/oob"
	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/internal/core"
)

var dbpath string

func cleanCLIDB() {

}
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
	}
	app.Run(os.Args)
}

func makeConf(c *cli.Context) *BWConfig {
	rv := core.BWConfig{}
	rv.Router.DB = ".cli.db"
	return &rv
}
func actionRouter(c *cli.Context) {
	bw := api.OpenBWContext(nil)
	oob := new(oob.Adapter)
	fmt.Println("router starting")
	go api.Start(bw)
	oob.Start(bw)
}
