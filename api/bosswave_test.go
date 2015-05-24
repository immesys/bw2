package api

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/util"
	"github.com/immesys/bw2/objects"
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

	mvk := namespace.GetVK()

	//TODO replace this with async_full implementations of CreateDOT
	//allow E1 to publish to a/*
	nToE1 := objects.CreateDOT(true, mvk, e1.GetVK())
	nToE1.SetAccessURI(mvk, "a/*")
	nToE1.SetCanPublish(true)
	nToE1.Encode(namespace.GetSK())

	//allow E2 to subscribe to a/b/* with plus privilege
	nToE2 := objects.CreateDOT(true, mvk, e2.GetVK())
	nToE2.SetAccessURI(mvk, "a/b/*")
	nToE2.SetCanConsume(true, true, false)
	nToE2.Encode(namespace.GetSK())

	//TODO replace this with async_full implementations of CreateChain
	dcE1, err := objects.CreateDChain(true, nToE1)
	if err != nil {
		panic(err)
	}
	dcE2, err := objects.CreateDChain(true, nToE2)
	if err != nil {
		panic(err)
	}

	sp := SubscribeParams{
		MVK:                mvk,
		URISuffix:          "a/b/c",
		PrimaryAccessChain: dcE2,
		ElaboratePAC:       FullElaboration,
		DoVerify:           true,
	}
	client2.Subscribe(&sp,
		func(code int, isnew bool, subid core.UniqueMessageID) {
			fmt.Println("Got Scode", code)
			if code != core.BWStatusOkay {
				fmt.Println("FAIL")
				return
			}
			pp := PublishParams{
				MVK:                mvk,
				URISuffix:          "a/b/c",
				PrimaryAccessChain: dcE1,
				ElaboratePAC:       FullElaboration,
				DoVerify:           true,
			}
			client1.Publish(&pp, func(code int) {
				fmt.Println("Got Pcode", code)
			})
		},
		func(m *core.Message) {
			fmt.Println("Got message")
		})

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
