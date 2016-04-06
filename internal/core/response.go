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

package core

import (
	"encoding/base64"
	"encoding/binary"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util/bwe"
)

type UniqueMessageID struct {
	Mid uint64
	Sig uint64
}

func (umid *UniqueMessageID) ToString() string {
	tmp := make([]byte, 16)
	binary.LittleEndian.PutUint64(tmp, umid.Mid)
	binary.LittleEndian.PutUint64(tmp[8:], umid.Mid)
	return base64.URLEncoding.EncodeToString(tmp)
}

func UniqueMessageIDFromString(s string) *UniqueMessageID {
	tmp := make([]byte, 16)
	tmp, err := base64.URLEncoding.DecodeString(s)
	if err != nil {
		return nil
	}
	rv := &UniqueMessageID{}
	rv.Mid = binary.LittleEndian.Uint64(tmp)
	rv.Sig = binary.LittleEndian.Uint64(tmp[8:])
	return rv
}

type StatusMessage struct {
	UMid UniqueMessageID
	Code int
}
type ObjectResponse struct {
	UMid    UniqueMessageID
	Objects []objects.PayloadObject
}

func (s *StatusMessage) Ok() bool {
	return s.Code == bwe.Okay
}
