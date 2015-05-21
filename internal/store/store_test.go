package store

import "testing"

func TestPutMessage(t *testing.T) {
	PutMessage("a/b/c", []byte("foobar"))
}
