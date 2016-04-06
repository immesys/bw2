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

package api

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util"
)

func TestBasicX(t *testing.T) {
	//Create the three entities in this test. E1 is publishing to namespace
	//E2 is subscribing to namespace
	e1 := objects.CreateNewEntity("contact1", "comment1", nil, 30*time.Hour)
	e2 := objects.CreateNewEntity("contact2", "comment2", nil, 30*time.Hour)
	namespace := objects.CreateNewEntity("contact3", "comment3", nil, 30*time.Hour)

	fmt.Printf("Created the three entities\ne1: %v\ne2: %v\nns: %v\n",
		crypto.FmtKey(e1.GetVK()), crypto.FmtKey(e2.GetVK()), crypto.FmtKey(namespace.GetVK()))
	bw := OpenBWContext(nil)
	client1 := bw.CreateClient(e1)
	client2 := bw.CreateClient(e2)
	clientN := bw.CreateClient(namespace)

	mvk := namespace.GetVK()

	cdp := CreateDotParams{
		To:                e1.GetVK(),
		MVK:               mvk,
		URISuffix:         "a/*",
		AccessPermissions: "p",
	}
	dToE1 := clientN.CreateDOT(&cdp)
	if dToE1 == nil {
		t.Fatalf("dot1 is nil")
	}
	fmt.Printf("dToE1 %+v\n", dToE1)
	cdp.To = e2.GetVK()
	cdp.AccessPermissions = "c*"
	dToE2 := clientN.CreateDOT(&cdp)
	if dToE2 == nil {
		t.Fatalf("dot2 is nil")
	}
	fmt.Printf("dToE2 %+v\n", dToE2)
	dcE1 := client1.CreateDotChain(&CreateDotChainParams{
		DOTs: []*objects.DOT{dToE1},
	})
	dcE2 := client1.CreateDotChain(&CreateDotChainParams{
		DOTs: []*objects.DOT{dToE2},
	})
	if dcE1 == nil || dcE2 == nil {
		t.FailNow()
	}

	gm := make(chan bool)
	client2.Subscribe(&SubscribeParams{
		MVK:                mvk,
		URISuffix:          "a/b/c",
		PrimaryAccessChain: dcE2,
		ElaboratePAC:       FullElaboration,
		DoVerify:           true,
	},
		func(code int, isnew bool, subid core.UniqueMessageID) {
			fmt.Println("Got Scode", code)
			if code != util.BWStatusOkay {
				fmt.Println("FAIL")
				gm <- false
			}
			client1.Publish(&PublishParams{
				MVK:                mvk,
				URISuffix:          "a/b/c",
				PrimaryAccessChain: dcE1,
				ElaboratePAC:       FullElaboration,
				DoVerify:           true,
			},
				func(code int) {
					fmt.Println("Got Pcode", code)
				})
		},
		func(m *core.Message) {
			fmt.Println("Got message")
			gm <- true
		})

	//Check if the test passed or we timed out
	select {
	case direct := <-gm:
		if !direct {
			t.FailNow()
			return
		}
	case <-time.After(3 * time.Second):
		fmt.Println("Timed out")
		t.FailNow()
		return
	}
}

func TestMatchTopic(t *testing.T) {
	TV := []struct {
		T string
		P string
		R bool
	}{
		{"a/b/c", "a/b/c", true},
		{"a/b/c", "a/+/c", true},
		{"a/b/c", "a/+/+/c", false},
		{"a/b/c", "a/*/c", true},
		{"a/c", "a/*/c", true},
		{"a/b/d/e/c", "a/*/c", true},
		{"a/b/d/e/d", "a/*/c/d", false},
	}
	for _, v := range TV {
		if MatchTopic(strings.Split(v.T, "/"), strings.Split(v.P, "/")) != v.R {
			t.Fail()
		}
	}
}
func TestRestrict(t *testing.T) {
	TV := []struct {
		T  string
		P  string
		Rs string
		Rb bool
	}{
		//case 0: no stars
		{"a/b/c", "a/b/c", "a/b/c", true},
		{"a/b", "a/b/c", "", false},
		{"a/b/c", "a/b", "", false},
		{"a/+/c", "a/b/c", "a/b/c", true},
		{"a/b/c", "a/+/c", "a/b/c", true},
		{"a/+/c", "a/+/c", "a/+/c", true},
		//
		//case 1: left star
		{"a/*", "a/b/c", "a/b/c", true},
		{"a/*", "a/*", "a/*", true},
		{"*/a", "a/b/c", "", false},
		{"*/a", "a/b/c/a", "a/b/c/a", true},
		{"*/a", "a", "a", true},
		{"*/b/c", "a/b/c", "a/b/c", true},
		{"a/*/c", "a/c", "a/c", true},
		{"a/*/c", "a/b/d/e/c", "a/b/d/e/c", true},
		{"a/*/c", "a/+/c", "a/+/c", true},
		{"a/+/c", "a/*/c", "a/+/c", true},
		{"+/*/+", "a/b/c/d", "a/b/c/d", true},
		//case 2: right star
		{"a/b/c", "a/*", "a/b/c", true},
		{"a/b/c", "*", "a/b/c", true},
		{"+/b/c", "*", "+/b/c", true},
		{"a/b/+", "*/+", "a/b/+", true},
		{"a/b/c", "*/c", "a/b/c", true},
		//case 3: both stars
		{"a/b/*/c/d", "a/b/x/*/y/c/d", "a/b/x/*/y/c/d", true},
		{"a/b/c/d/*/x/y", "a/*/y", "a/b/c/d/*/x/y", true},
		{"a/b/c/d/*/x/y", "a/*/w/x/y", "a/b/c/d/*/w/x/y", true},
		{"a/b/*/x/y", "a/b/c/d/*/y", "a/b/c/d/*/x/y", true},
		{"a/b/c", "a/b/c", "a/b/c", true},
		{"a/*", "a/b/c", "a/b/c", true},
		{"a/b/c", "a/*", "a/b/c", true},
		{"a/b/c", "*/c", "a/b/c", true},
		{"*/c", "a/b/c", "a/b/c", true},
		{"a/b/c/*/x/y/z", "a/b/1/*/2/y/z", "", false},
	}
	for _, v := range TV {
		res, ok := util.RestrictBy(v.T, v.P)
		if res != v.Rs || ok != v.Rb {
			fmt.Printf("Fail %+v, got %v\n", v, res)
			t.Fail()
		}
	}
}
