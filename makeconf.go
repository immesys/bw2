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
