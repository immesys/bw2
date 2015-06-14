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

	"github.com/codegangsta/cli"
	"github.com/immesys/bw2/api"
	"github.com/immesys/bw2/internal/crypto"
)

func makeConf(c *cli.Context) {
	conf, err := os.Create("bw2.ini")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	err = conf.Chmod(0600)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	sk, vk := crypto.GenerateKeypair()
	tsk := crypto.FmtKey(sk)
	tvk := crypto.FmtKey(vk)
	file := []string{
		("# generated for " + api.BW2Version + "\n"),
		("[router]\n"),
		("VK=" + tvk + "\n"),
		("SK=" + tsk + "\n"),
		("DB=.bw.db\n"),
		("[native]\n"),
		("ListenOn=:4514\n"),
		("[oob]\n"),
		("ListenOn=:28589\n"),
		("[affinity]\n"),
		("# add MVK=<key>,<cert> lines\n"),
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
}
