package core

import (
	"encoding/base64"
	"time"
)

var Forever = time.Date(2050, time.January, 1, 1, 1, 1, 1, time.UTC)

func SplitURI(uri string) (mvk []byte, urisuffix string) {
	rv, err := base64.URLEncoding.DecodeString(uri[:32])
	if err != nil {
		panic(err)
	}
	return rv, uri[33:]
}

/*
type SubReq struct {
	//	Type     uint8
	DChain   []Dot
	MVK      []byte
	Topic    string
	Tap      bool
	Client   *Client
	Dispatch func(m *Message)
}
*/
