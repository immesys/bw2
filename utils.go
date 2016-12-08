package main

import (
	"fmt"
	"os"

	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
)

func confLog(cfg *core.BWConfig) {
	if cfg == nil {
		api.InitLog("bw2.log")
	} else {
		api.InitLog(cfg.Router.LogPath)
	}
}

func doExit(bw *api.BW, code int, msg string) {
	if msg != "" {
		fmt.Println(msg)
	}
	os.Exit(code)
}
func publishROs(cl *api.BosswaveClient, target string, ros []objects.RoutingObject) {
	panic("We need to change this mechanism")
}

func distEntity(e *objects.Entity, cl *api.BosswaveClient, to []string) {
	panic("We have not really solved this")
}
func distDOT(d *objects.DOT, cl *api.BosswaveClient, to []string) {
	panic("We have not really solved this")

}
func distChain(c *objects.DChain, cl *api.BosswaveClient, to []string) {
	panic("We have not really solved this")
}
