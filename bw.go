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
	"os"
	"runtime"

	"github.com/immesys/bw2/adapter/oob"
	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/util"
	"github.com/urfave/cli"
)

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU())
	app := cli.NewApp()
	app.Name = "bw2"
	app.Usage = "BossWave 2 universal tool. Run public or private routers, manage DoTs and DChains, and more"
	app.Version = util.BW2Version
	app.Flags = []cli.Flag{
		cli.StringSliceFlag{
			Name:   "a",
			Usage:  "add available entityfile",
			EnvVar: "BW2_ENTITIES",
		},
		cli.StringFlag{
			Name:   "agent",
			Usage:  "set the agent router",
			Value:  "127.0.0.1:28589",
			EnvVar: "BW2_AGENT",
		},
	}
	nflag := cli.BoolFlag{
		Name:  "nopublish, n",
		Usage: "do not publish to the registry",
	}
	bflag := cli.StringFlag{
		Name:   "bankroll, b",
		Usage:  "entity to pay for operation",
		EnvVar: "BW2_DEFAULT_BANKROLL",
	}
	oflag := cli.StringFlag{
		Name:  "outfile, o",
		Usage: "save the result to this file",
	}
	app.Commands = []cli.Command{
		{
			Name:   "router",
			Usage:  "start a router as configured in the bw2.ini file",
			Action: cli.ActionFunc(actionRouter),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "conf",
					Usage: "override the default config file",
				},
			},
		},
		// {
		// 	Name:   "dtrig",
		// 	Usage:  "if you ever see this, email michael, he messed up",
		// 	Action: cli.ActionFunc( actionDTrig,
		// },
		{
			Name:   "makeconf",
			Usage:  "create a new bw2.ini file",
			Action: cli.ActionFunc(makeConf),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "logfile",
					Value: "",
					Usage: "The logfile to put in the config",
				},
				cli.StringFlag{
					Name:  "dbpath",
					Value: "",
					Usage: "The dbpath to put in the config",
				},
				cli.StringFlag{
					Name:  "conf",
					Usage: "override the default config file",
				},
			},
		},
		{
			Name:    "mkentity",
			Aliases: []string{"mke"},
			Usage:   "create a new entity",
			Action:  cli.ActionFunc(actionMkEntity),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:   "contact, c",
					Value:  "",
					Usage:  "contact attribute e.g. 'Oski Bear <oski@berkeley.edu>'",
					EnvVar: "BW2_DEFAULT_CONTACT",
				},
				cli.StringFlag{
					Name:  "comment, m",
					Value: "",
					Usage: "comment attribute e.g. 'Development Key'",
				},
				cli.StringSliceFlag{
					Name:   "revoker, r",
					Value:  &cli.StringSlice{},
					Usage:  "add a delegated revoker to this entity",
					EnvVar: "BW2_DEFAULT_REVOKER",
				},
				cli.StringFlag{
					Name:   "expiry, e",
					Value:  "30d",
					Usage:  "set the expiry measured from now e.g. 10d5h10s",
					EnvVar: "BW2_DEFAULT_EXPIRY",
				},
				oflag, nflag, bflag,
			},
		},
		{
			Name:   "mget",
			Usage:  "get the metadata for a URI",
			Action: cli.ActionFunc(actionMget),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:   "entity, e",
					Usage:  "the entity to use",
					Value:  "",
					EnvVar: "BW2_DEFAULT_ENTITY",
				},
				cli.StringFlag{
					Name:  "key, k",
					Usage: "the key to resolve (all if omitted)",
					Value: "",
				},
				cli.BoolFlag{
					Name:  "i, verbose",
					Usage: "show where the values are inherited fromr",
				},
			},
		},
		{
			Name:   "mset",
			Usage:  "set a metadata key for a URI",
			Action: cli.ActionFunc(actionMset),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:   "entity, e",
					Usage:  "the entity to use",
					Value:  "",
					EnvVar: "BW2_DEFAULT_ENTITY",
				},
				cli.StringFlag{
					Name:  "uri, u",
					Usage: "the uri to set on",
					Value: "",
				},
				cli.StringFlag{
					Name:  "key, k",
					Usage: "the key to set",
					Value: "",
				},
				cli.StringFlag{
					Name:  "val, v",
					Usage: "the value to set",
					Value: "",
				},
			},
		},
		{
			Name:   "mdel",
			Usage:  "delete a metadata key for a URI",
			Action: cli.ActionFunc(actionMdel),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:   "entity, e",
					Usage:  "the entity to use",
					Value:  "",
					EnvVar: "BW2_DEFAULT_ENTITY",
				},
				cli.StringFlag{
					Name:  "key, k",
					Usage: "the key to delete",
					Value: "",
				},
				cli.StringFlag{
					Name:  "uri, u",
					Usage: "the uri to delete it from",
					Value: "",
				},
			},
		},
		{
			Name:    "coldstore",
			Aliases: []string{"redeem", "cs"},
			Usage:   "view or redeem coldstore accounts",
			Action:  cli.ActionFunc(actionColdStore),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "to, t",
					Value: "",
					Usage: "the account to transfer the coldstore to",
				},
			},
		},
		{
			Name:   "xfer",
			Usage:  "transfer Ether to an address",
			Action: cli.ActionFunc(actionXfer),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "to, t",
					Value: "",
					Usage: "the account to transfer to",
				},
				cli.IntFlag{
					Name:  "accountnum",
					Value: 0,
					Usage: "the account number to transfer from",
				},
				cli.StringFlag{
					Name:  "ether",
					Value: "",
					Usage: "an amount in ether",
				},
				cli.StringFlag{
					Name:  "milli",
					Value: "",
					Usage: "an amount in milliEther",
				},
				cli.StringFlag{
					Name:  "micro",
					Value: "",
					Usage: "an amount in microEther",
				}, bflag,
			},
		},
		{
			Name:   "status",
			Usage:  "get the local router status",
			Action: cli.ActionFunc(actionStatus),
		},
		{
			Name:    "mkdot",
			Aliases: []string{"mkd"},
			Usage:   "create a new access dot",
			Action:  cli.ActionFunc(actionMkDOT),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:   "contact, c",
					Value:  "",
					Usage:  "contact attribute e.g. 'Oski Bear <oski@berkeley.edu>'",
					EnvVar: "BW2_DEFAULT_CONTACT",
				},
				cli.StringFlag{
					Name:  "comment, m",
					Value: "",
					Usage: "comment attribute e.g. 'Development Key'",
				},
				cli.StringSliceFlag{
					Name:   "revoker, r",
					Value:  &cli.StringSlice{},
					Usage:  "add a delegated revoker to this entity",
					EnvVar: "BW2_DEFAULT_REVOKER",
				},
				cli.StringFlag{
					Name:   "expiry, e",
					Value:  "90d",
					Usage:  "set the expiry measured from now e.g. 3d7h20m",
					EnvVar: "BW2_DEFAULT_EXPIRY",
				},
				cli.StringFlag{
					Name:   "permissions, x",
					Usage:  "the access permissions string e.g LPC*T*",
					Value:  "LPC*",
					EnvVar: "BW2_DEFAULT_PERMISSIONS",
				},
				cli.StringFlag{
					Name:  "uri, u",
					Usage: "the URI to grant on",
					Value: "",
				},
				cli.StringFlag{
					Name:   "from, f",
					Usage:  "the entity to grant from",
					Value:  "",
					EnvVar: "BW2_DEFAULT_ENTITY",
				},
				cli.StringFlag{
					Name:  "to, t",
					Usage: "the entity to grant to",
					Value: "",
				},
				cli.IntFlag{
					Name:   "ttl, l",
					Usage:  "the TTL (number of hops) this DOT transfers",
					Value:  0,
					EnvVar: "BW2_DEFAULT_TTL",
				},
				oflag, nflag, bflag,
			},
		},
		{
			Name:    "inspect",
			Aliases: []string{"i"},
			Usage:   "inspect a file, alias, VK or address",
			Action:  cli.ActionFunc(actionInspect),
			Flags: []cli.Flag{
				cli.BoolFlag{
					Name:  "publish, p",
					Usage: "publish inspected objects to the registry",
				}, bflag,
			},
		},
		{
			Name:   "mkdroffer",
			Usage:  "create a new designated router offer",
			Action: cli.ActionFunc(actionMkDRO),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "dr",
					Usage: "the designated router entity",
					Value: "",
				},
				cli.StringFlag{
					Name:  "ns",
					Usage: "the namespace (VK or alias) to grant to",
					Value: "",
				},
				bflag,
			},
		},
		{
			Name:   "mkalias",
			Usage:  "create an alias",
			Action: cli.ActionFunc(actionMkAlias),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "long",
					Usage: "create a long alias with the given key",
					Value: "",
				},
				cli.BoolFlag{
					Name:  "short",
					Usage: "create a short alias",
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
				bflag,
			},
		},
		{
			Name:    "listDRoffers",
			Aliases: []string{"lsdro"},
			Usage:   "list designated router offers for a namespace",
			Action:  cli.ActionFunc(actionLsDRO),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "ns",
					Usage: "the namespace (VK or alias)",
					Value: "",
				},
			},
		},
		{
			Name:    "acceptDRoffer",
			Aliases: []string{"adro"},
			Usage:   "accept a designated router offer",
			Action:  cli.ActionFunc(actionADRO),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "dr",
					Usage: "the designated router (VK or alias) to accept",
					Value: "",
				},
				cli.StringFlag{
					Name:  "ns",
					Usage: "the namespace entity",
					Value: "",
				},
				bflag,
			},
		},
		{
			Name:    "revokeDROffer",
			Aliases: []string{"rdro"},
			Usage:   "revoke a designated router offer",
			Action:  cli.ActionFunc(actionRDRO),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "dr",
					Usage: "the designated router entity",
					Value: "",
				},
				cli.StringFlag{
					Name:  "ns",
					Usage: "the namespace entity to revoke",
					Value: "",
				},
				bflag,
			},
		},
		{
			Name:    "revokeAcceptedDROffer",
			Aliases: []string{"radro"},
			Usage:   "revoke an acceptance of a designated router offer",
			Action:  cli.ActionFunc(actionRADRO),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "dr",
					Usage: "the designated router that made the offer",
					Value: "",
				},
				cli.StringFlag{
					Name:  "ns",
					Usage: "the namespace entity that accepted the offer",
					Value: "",
				},
				bflag,
			},
		},
		{
			Name:   "usrv",
			Usage:  "accept a designated router SRV record",
			Action: cli.ActionFunc(actionUSRV),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "dr",
					Usage: "the designated router to update",
					Value: "",
				},
				cli.StringFlag{
					Name:  "srv",
					Usage: "the srv record e.g. 100.12.42.23:4514",
					Value: "",
				},
				bflag,
			},
		},
		{
			Name:    "buildchain",
			Aliases: []string{"bc"},
			Usage:   "build a DOT Chain",
			Action:  cli.ActionFunc(actionBuildChain),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "uri, u",
					Usage: "the URI to build a chain for",
					Value: "",
				},
				cli.StringFlag{
					Name:  "permissions, x",
					Usage: "the permissions to try build",
					Value: "PC",
				},
				cli.StringFlag{
					Name:   "to, t",
					Usage:  "the VK to build a chain to",
					Value:  "",
					EnvVar: "BW2_DEFAULT_ENTITY",
				},
				cli.BoolFlag{
					Name:  "verbose, v",
					Usage: "print out the contents of the chains",
				},
				cli.BoolFlag{
					Name:  "publish, p",
					Usage: "publish inspected objects to the registry",
				},
				bflag,
			},
		},
		{
			Name:    "subscribe",
			Aliases: []string{"sub", "s"},
			Action:  cli.ActionFunc(actionSubscribe),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:   "entity, e",
					Usage:  "the entity to subscribe as",
					Value:  "",
					EnvVar: "BW2_DEFAULT_ENTITY",
				},
			},
		},
		{
			Name:    "query",
			Aliases: []string{"q"},
			Action:  cli.ActionFunc(actionQuery),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:   "entity, e",
					Usage:  "the entity to query as",
					Value:  "",
					EnvVar: "BW2_DEFAULT_ENTITY",
				},
			},
		},
		{
			Name:   "revoke",
			Usage:  "revoke [OPTIONS] objects...",
			Action: cli.ActionFunc(actionRevoke),
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:   "from, f",
					Usage:  "the entity to generate the revocation with",
					Value:  "",
					EnvVar: "BW2_DEFAULT_ENTITY",
				}, cli.StringFlag{
					Name:  "vk",
					Usage: "the entity VK to revoke",
					Value: "",
				}, cli.StringFlag{
					Name:  "dot",
					Usage: "the DOT hash to revoke",
					Value: "",
				}, cli.StringFlag{
					Name:  "comment, m",
					Usage: "the revocation comment",
					Value: "",
				},
				bflag, nflag, oflag,
			},
		},
	}
	app.Run(os.Args)
}

func actionRouter(c *cli.Context) error {
	cfg := c.String("conf")
	var config *core.BWConfig
	config = core.LoadConfig(cfg)
	confLog(config)
	bw, shd := api.OpenBWContext(config)
	// go func() {
	// 	for {
	// 		time.Sleep(5 * time.Second)
	// 		fmt.Println("num goroutines:", runtime.NumGoroutine())
	// 	}
	// }()
	if bw.Config.Native.ListenOn != "" {
		go api.Start(bw)
	} else {
		fmt.Println("not starting native server: no listen address")
	}
	if bw.Config.OOB.ListenOn != "" {
		oob := new(oob.Adapter)
		go oob.Start(bw)
	} else {
		fmt.Println("not starting oob server: no listen address")
	}
	<-shd
	return nil
}
