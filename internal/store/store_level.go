// +build !rocksdb

package store

import (
	"github.com/immesys/bw2/internal/db"
	dbi "github.com/immesys/bw2/internal/level"
)

var dbi_ErrObjNotFound = dbi.ErrObjNotFound

func dbi_RawInitialize(dbname string) {
	dbi.RawInitialize(dbname)
}

func dbi_PutObject(cf int, key []byte, val []byte) {
	dbi.PutObject(cf, key, val)
}

func dbi_GetObject(cf int, key []byte) ([]byte, error) {
	return dbi.GetObject(cf, key)
}

func dbi_DeleteObject(cf int, key []byte) {
	dbi.DeleteObject(cf, key)
}

func dbi_Exists(cf int, key []byte) bool {
	return dbi.Exists(cf, key)
}

func dbi_CreateIterator(cf int, prefix []byte) db.BWDBIterator {
	return dbi.CreateIterator(cf, prefix)
}
