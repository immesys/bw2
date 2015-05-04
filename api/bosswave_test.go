package api

import (
	"fmt"
	"strings"
	"testing"

	"github.com/immesys/bw2/internal/core"
)

func MakeSub(topic string, onhit func(m *core.Message)) *core.SubReq {
	rv := &core.SubReq{Topic: topic, Dispatch: onhit}
	return rv
}
func MakeMsg(topic string, msg string) *core.Message {
	rv := &core.Message{TopicSuffix: topic, Payload: []byte(msg)}
	return rv
}
func TestBasic0(t *testing.T) {
	bw := OpenBWContext(nil)
	// f := func(s string) {
	// 	fmt.Printf("Got: %v", s)
	// }
	client1 := bw.CreateClient(func() {
		fmt.Println("C1 Queue changed")
	})
	client1.Subscribe(MakeSub("/a/*/b", nil))
	client2 := bw.CreateClient(nil)
	client2.Subscribe(MakeSub("/a/b/b/b", func(m *core.Message) {
		fmt.Println("Got message: ", string(m.Payload))
	}))
	client1.Publish(MakeMsg("/a/b/b/b", "foo"))
	//client.Publish("/a/b/c", "foo")
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
		res, ok := RestrictBy(v.T, v.P)
		if res != v.Rs || ok != v.Rb {
			fmt.Printf("Fail %+v, got %v\n", v, res)
			t.Fail()
		}
	}
}
