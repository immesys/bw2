package bw2

// import (
// 	"net"
// 	"os"
//
// 	log "github.com/cihub/seelog"
// 	"github.com/immesys/bw2/internal/core"
// )
//
// func Start(bw *BW) {
// 	ln, err := net.Listen("tcp", bw.Config.Native.ListenOn)
// 	if err != nil {
// 		log.Criticalf("Could not open native adapter socket: %v", err)
// 		os.Exit(1)
// 	}
// 	for {
// 		conn, err := ln.Accept()
// 		if err != nil {
// 			log.Criticalf("Socket error: %v", err)
// 		}
// 		go handleSession(bw, conn)
// 	}
// }
//
// func handleSession(bw *BW, conn net.Conn) {
//
// }
//
// func readMessage(conn net.Conn) *core.Message {
// 	buf := make([]byte, 0, 10000)
// 	conn.Read(buf)
//
// }
