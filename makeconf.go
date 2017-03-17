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
	"html/template"
	"io/ioutil"
	"os"
	"path/filepath"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util"
	"github.com/urfave/cli"
)

type configparams struct {
	BW2Version string
	Entfile    string
	DBPath     string
	Lpath      string
	ListenOn   string
	AmLight    string
}

const configTemplate = `# Generated for {{.BW2Version}}
[config]
# this is the version of config file
Version=2

[router]
# this entity is used only if you are a DR
Entity={{.Entfile}}
DB={{.DBPath}}
LogPath={{.Lpath}}

[native]
# this is for DR peering. You can set this to an
# internal IP if you are not planning on acting
# as a router
ListenOn=:4514

[oob]
# OOB clients must be trusted. It is best to leave this
# on 127.0.0.1 but if you are in a container you must
# set it to 0.0.0.0
ListenOn={{.ListenOn}}

[altruism]
# this decides how many light clients you will allow
# to connect to you.
MaxLightPeers=20
# this decides what fraction of total resources can
# be spent on helping light clients
MaxLightResourcePercentage=50

[p2p]
# having more peers may increase bandwidth usage
# but also improve your sync speed
MaxPeers=20
# Are we a light client?
IAmLight={{.AmLight}}
# What networks will we allow p2p traffic to/from
PermittedNetworks=0.0.0.0/0,::0/0

[mining]
# A nonzero value implies we will CPU mine
Threads=0
# Where the mining ether goes.
# The 0x475b312fa8c3cdc6a770694d2929b9dc66fe0f33
# address is the 410 Reserve Bank used for funding
# paper experiments. You can check its balance
# with bw2 i reservebank
Benificiary=0x475b312fa8c3cdc6a770694d2929b9dc66fe0f33
`

func makeConf(c *cli.Context) error {
	fname := "bw2.ini"
	if c.String("conf") != "" {
		fname = c.String("conf")
	}
	conf, err := os.Create(fname)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	err = conf.Chmod(0600)
	if err != nil {
		fmt.Println("WARN: chmod failed:", err)
	}
	abs, err := filepath.Abs(fname)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	configdir := filepath.Dir(abs)
	ent := objects.CreateNewEntity("", "", nil)
	wrapped := make([]byte, len(ent.GetSigningBlob())+1)
	copy(wrapped[1:], ent.GetSigningBlob())
	wrapped[0] = objects.ROEntityWKey
	entfile := filepath.Join(configdir, "router.ent")
	err = ioutil.WriteFile(entfile, wrapped, 0600)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	lpath := filepath.Join(configdir, "bw2.log")
	if c.String("logfile") != "" {
		lpath = c.String("logfile")
	}
	dbpath := filepath.Join(configdir, ".bw.db")
	if c.String("dbpath") != "" {
		dbpath = c.String("dbpath")
	}
	amlight := "false"
	if c.Bool("light") {
		amlight = "true"
	}
	listenon := "127.0.0.1:28589"
	if c.Bool("listenglobal") {
		listenon = "0.0.0.0:28589"
	}
	tmp, err := template.New("root").Parse(configTemplate)
	if err != nil {
		panic(err)
	}
	params := configparams{
		BW2Version: util.BW2Version,
		Entfile:    entfile,
		DBPath:     dbpath,
		Lpath:      lpath,
		ListenOn:   listenon,
		AmLight:    amlight,
	}
	err = tmp.ExecuteTemplate(conf, "root", params)
	if err != nil {
		panic(err)
	}
	err = conf.Close()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return nil
}
