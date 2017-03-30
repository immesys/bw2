// Copyright 2015 The Vuvuzela Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package shuffle

import (
	"testing"

	"vuvuzela.io/crypto/rand"
)

func TestShuffle(t *testing.T) {
	n := 64
	x := make([][]byte, n)
	for i := 0; i < n; i++ {
		x[i] = []byte{byte(i)}
	}

	s := New(rand.Reader, len(x))
	s.Shuffle(x)

	allSame := true
	for i := 0; i < n; i++ {
		if x[i][0] != byte(i) {
			allSame = false
		}
	}

	if allSame {
		t.Errorf("shuffler isn't shuffling")
	}

	s.Unshuffle(x)

	for i := 0; i < n; i++ {
		if x[i][0] != byte(i) {
			t.Errorf("unshuffle does not undo shuffle")
			break
		}
	}
}
