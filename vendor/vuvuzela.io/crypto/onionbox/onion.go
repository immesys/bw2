// Copyright 2015 The Vuvuzela Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package onionbox implements onion encryption.
package onionbox // import "vuvuzela.io/crypto/onionbox"

import (
	"golang.org/x/crypto/nacl/box"

	"vuvuzela.io/crypto/rand"
)

// Overhead of one layer
const Overhead = 32 + box.Overhead

func Seal(message []byte, nonce *[24]byte, publicKeys []*[32]byte) ([]byte, []*[32]byte) {
	onion := message
	sharedKeys := make([]*[32]byte, len(publicKeys))
	for i := len(publicKeys) - 1; i >= 0; i-- {
		myPublicKey, myPrivateKey, err := box.GenerateKey(rand.Reader)
		if err != nil {
			panic(err)
		}
		sharedKeys[i] = new([32]byte)
		box.Precompute(sharedKeys[i], (*[32]byte)(publicKeys[i]), myPrivateKey)

		onion = box.SealAfterPrecomputation(myPublicKey[:], onion, nonce, sharedKeys[i])
	}

	return onion, sharedKeys
}

func Open(onion []byte, nonce *[24]byte, sharedKeys []*[32]byte) ([]byte, bool) {
	var ok bool
	message := onion
	for i := 0; i < len(sharedKeys); i++ {
		message, ok = box.OpenAfterPrecomputation(nil, message, nonce, sharedKeys[i])
		if !ok {
			return nil, false
		}
	}

	return message, true
}
