package bw2

import "testing"

func TestBasic0(t *testing.T) {
	bw := OpenBWContext(nil)
	// f := func(s string) {
	// 	fmt.Printf("Got: %v", s)
	// }
	client := bw.CreateClient()
	client.Subscribe("/a/b")
	client.Publish("/a/b", "foo")
}
