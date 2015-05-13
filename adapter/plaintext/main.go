package plaintext

import (
	"bufio"
	"fmt"
	"net"
	"os"

	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/api"
)

type Adapter struct {
	bw *api.BW
}

func (a *Adapter) Start(bw *api.BW) {
	ln, err := net.Listen("tcp", bw.Config.Adapters.Plaintext.ListenOn)
	if err != nil {
		fmt.Printf("Could not listen on '%s' for PlaintextAdapter: %v\n",
			bw.Config.Adapters.Plaintext.ListenOn, err)
		os.Exit(1)
	}
	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Warnf("Plaintext socket error: %v", err)
		}
		go a.handleClient(conn)
	}
}

func (a *Adapter) handleClient(conn net.Conn) {
	w := bufio.NewWriter(conn)
	r := bufio.NewReader(conn)
	rw := bufio.NewReadWriter(r, w)
	rw.WriteString("BOSSWAVE " + api.BW2Version + "\n")
	rw.WriteString("Ready.\n")
	rw.Flush()
}
