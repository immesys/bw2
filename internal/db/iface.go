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

package db

const (
	CFDot    = 1
	CFDChain = 2
	CFMsg    = 3
	CFMsgI   = 4
	CFEntity = 5
)

type BWDB interface {
	Initialize(dbname string)
	PutObject(cf int, key []byte, val []byte)
	GetObject(cf int, key []byte) ([]byte, error)
	DeleteObject(cf int, key []byte)
	Exists(cf int, key []byte) bool
	CreateIterator(cf int, prefix []byte) BWDBIterator
}

type BWDBIterator interface {
	Next()
	OK() bool
	Key() []byte
	Value() []byte
	Release()
}
