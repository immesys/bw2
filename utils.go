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

//We are going to get rid of this soon
/*
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
		cfg.Router.LogPath = "/tmp/bw.log"
	}
	rv, _ := api.OpenBWContext(cfg)
	return rv
}*/
func doExit(bw *api.BW, code int, msg string) {
	if msg != "" {
		fmt.Println(msg)
	}
	os.Exit(code)
}
func publishROs(cl *api.BosswaveClient, target string, ros []objects.RoutingObject) {
	panic("We need to change this mechanism")
}

/*
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

}*/
/*
func getRandomEntity() *objects.Entity {
	dur := 10 * time.Minute
	ent, err := api.CreateEntity(&api.CreateEntityParams{
		ExpiryDelta: &dur,
		Contact:     "ephemeral",
		Comment:     "ephemeral",
	})
	if err != nil {
		panic(err)
	}
	return ent
}*/

func distEntity(e *objects.Entity, cl *api.BosswaveClient, to []string) {
	panic("We have not really solved this")
	/*
		core.DistributeRO(cl.BW().Entity, e, cl.CL())
		for _, tgt := range to {
			publishROs(cl, tgt, []objects.RoutingObject{e})
		}
	*/
}
func distDOT(d *objects.DOT, cl *api.BosswaveClient, to []string) {
	panic("We have not really solved this")
	/*
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
	*/
}
func distChain(c *objects.DChain, cl *api.BosswaveClient, to []string) {
	panic("We have not really solved this")
	/*
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
	*/
}

/*
What does this do??
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
*/
