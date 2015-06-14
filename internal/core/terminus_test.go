package core

import (
	"fmt"
	"testing"
	"time"

	"github.com/immesys/bw2/objects"
)

var mid uint64

func makeLightPubMessage(topic string, content string) *Message {
	po, _ := objects.CreateOpaquePayloadObjectDF("64.0.1.0", []byte(content))
	m := Message{
		Type:           TypePublish,
		MessageID:      mid,
		TopicSuffix:    topic,
		Topic:          topic,
		PayloadObjects: []objects.PayloadObject{po},
	}
	mid++
	return &m
}
func makeLightSubMessage(topic string) *Message {
	m := Message{
		Type:        TypeSubscribe,
		MessageID:   mid,
		TopicSuffix: topic,
		Topic:       topic,
	}
	mid++
	return &m
}
func blockSub(c *Client, t string) chan string {
	rv := make(chan string)
	c.Subscribe(makeLightSubMessage(t),
		func(m *Message, id UniqueMessageID) {
			rv <- string(m.PayloadObjects[0].GetContent())
		})
	return rv
}
func doPub(c *Client, t string, m string) {
	c.Publish(makeLightPubMessage(t, m))
}

func TestPS0(t *testing.T) {
	tm := CreateTerminus()
	c1 := tm.CreateClient()
	c2 := tm.CreateClient()
	rv := blockSub(c1, "a/b/c")
	doPub(c2, "a/b/c", "foo")
	select {
	case v := <-rv:
		if v == "foo" {
			return
		}
	case _ = <-time.After(3 * time.Second):
		t.FailNow()
		return
	}
}

func TestPSVec(t *testing.T) {
	tvec := []struct {
		ST string
		PT string
		V  bool
	}{
		{"a/b/c", "a/b/c", true},
		{"a/b/+", "a/b/c", true},
		{"a/+/c", "a/b/c", true},
		{"a/+/c", "a/b/c/d", false},
		{"a/*", "a/b/c", true},
		{"*/!foo", "a/b/c/!foo", true},
		{"*/!foo", "a/b/c/!foo/a", false},
		{"a/b/*/!foo", "a/b/c/!foo", true},
		{"a/b/*/!foo", "a/b/!foo", true},
		{"a/b/+/!foo", "a/b/!foo", false},
		{"a/b/+/!foo", "a/b/d/!foo", true},
		{"a/b/*/!foo", "a/c/!foo", false},
		{"a/+/c/*", "a/b/!foo", false},
		{"a/+/c/*", "a/b/c/!foo", true},
	}
	for idx, tc := range tvec {
		tm := CreateTerminus()
		c1 := tm.CreateClient()
		c2 := tm.CreateClient()
		rc := blockSub(c1, tc.ST)
		doPub(c2, tc.PT, "foo")
		var got bool
		select {
		case _ = <-rc:
			got = true
		case _ = <-time.After(500 * time.Millisecond):
			got = false
		}
		if got != tc.V {
			fmt.Println("Test case", idx, " failed")
			t.Fail()
		} else {
			fmt.Println("Test case", idx, " ok")
		}
	}
}
