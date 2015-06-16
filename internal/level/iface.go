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

package level

import (
	"errors"
	"fmt"
	"os"
	"path"
	"strconv"

	"github.com/syndtr/goleveldb/leveldb"
	"github.com/syndtr/goleveldb/leveldb/iterator"
	"github.com/syndtr/goleveldb/leveldb/util"
)

var doneInit bool
var dbh []*leveldb.DB

func RawInitialize(dbname string) {
	if doneInit {
		return
	}
	os.MkdirAll(dbname, 0755)
	for i := 0; i < CFEntity; i++ {
		db, err := leveldb.OpenFile(path.Join(dbname, strconv.Itoa(i)), nil)
		if err != nil {
			fmt.Println("DB error: ", err)
			os.Exit(1)
		}
		dbh = append(dbh, db)
	}
	doneInit = true
}

const (
	CFDot    = 1
	CFDChain = 2
	CFMsg    = 3
	CFMsgI   = 4
	CFEntity = 5
)

//ErrObjNotFound is returned from GetObject if the object cannot be found
var ErrObjNotFound = errors.New("Object Not Found")

func PutObject(cf int, key []byte, val []byte) {
	err := dbh[cf-1].Put(key, val, nil)
	if err != nil {
		panic(err)
	}
}

func GetObject(cf int, key []byte) ([]byte, error) {
	rv, err := dbh[cf-1].Get(key, nil)
	if err == leveldb.ErrNotFound {
		return nil, ErrObjNotFound
	}
	if err != nil {
		return nil, err
	}
	return rv, nil
}

func DeleteObject(cf int, key []byte) {
	dbh[cf-1].Delete(key, nil)
}

func Exists(cf int, key []byte) bool {
	rv, err := dbh[cf-1].Has(key, nil)
	if err != nil {
		panic(err)
	}
	return rv
}

type Iterator struct {
	prefix []byte
	state  iterator.Iterator
}

func CreateIterator(cf int, prefix []byte) *Iterator {
	it := dbh[cf-1].NewIterator(util.BytesPrefix(prefix), nil)
	it.Next()
	return &Iterator{prefix: prefix, state: it}
}

func (i *Iterator) Next() {
	i.state.Next()
}
func (i *Iterator) OK() bool {
	return i.state.Valid()
}
func (i *Iterator) Key() []byte {
	return i.state.Key()
}
func (i *Iterator) Value() []byte {
	return i.state.Value()
}
func (i *Iterator) Release() {
	i.state.Release()
}
