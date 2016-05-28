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
	"path/filepath"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util"
	"github.com/urfave/cli"
)

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
	entfile := configdir + "/" + "router.ent"
	err = ioutil.WriteFile(entfile, wrapped, 0600)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	lpath := "bw2.log"
	if c.String("logfile") != "" {
		lpath = c.String("logfile")
	}
	dbpath := ".bw.db"
	if c.String("dbpath") != "" {
		dbpath = c.String("dbpath")
	}
	file := []string{
		("# generated for " + util.BW2Version + "\n"),
		("[router]\n"),
		("Entity=" + entfile + "\n"),
		("DB=" + dbpath + "\n"),
		("LogPath=" + lpath + "\n"),
		("[native]\n"),
		("ListenOn=:4514\n"),
		("[oob]\n"),
		("ListenOn=127.0.0.1:28589\n"),
	}
	for _, s := range file {
		_, err := conf.WriteString(s)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	}
	err = conf.Close()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return nil
}
