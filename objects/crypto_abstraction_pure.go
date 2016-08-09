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

// +build purego

package objects

import (
	"encoding/base64"
	"errors"

	"golang.org/x/crypto/ed25519"
)

func SignBlob(sk []byte, vk []byte, into []byte, blob []byte) {
	catsk := make([]byte, 64)
	copy(catsk[0:32], sk)
	copy(catsk[32:64], vk)
	sig := ed25519.Sign(catsk, blob)
	copy(into, sig)
}

//VerifyBlob returns true if the sig is ok, false otherwise
func VerifyBlob(vk []byte, sig []byte, blob []byte) bool {
	return ed25519.Verify(vk, blob, sig)
}

func GenerateKeypair() (sk []byte, vk []byte) {
	vk, sk, err := ed25519.GenerateKey(nil)
	if err != nil {
		panic(err)
	}
	return vk, sk[:32]
}

//
// func CheckKeypair(sk []byte, vk []byte) bool {
// 	return cgocrypto.CheckKeypair(sk, vk)
// }

func FmtKey(key []byte) string {
	return base64.URLEncoding.EncodeToString(key)
}

func UnFmtKey(key string) ([]byte, error) {
	rv, err := base64.URLEncoding.DecodeString(key)
	if len(rv) != 32 {
		return nil, errors.New("Invalid length")
	}
	return rv, err
}

func FmtSig(sig []byte) string {
	return base64.URLEncoding.EncodeToString(sig)
}
func UnFmtSig(sig string) ([]byte, error) {
	rv, err := base64.URLEncoding.DecodeString(sig)
	if len(rv) != 64 {
		return nil, errors.New("Invalid length")
	}
	return rv, err
}

func FmtHash(hash []byte) string {
	return base64.URLEncoding.EncodeToString(hash)
}
func UnFmtHash(hash string) ([]byte, error) {
	rv, err := base64.URLEncoding.DecodeString(hash)
	if len(rv) != 32 {
		return nil, errors.New("Invalid length")
	}
	return rv, err
}
