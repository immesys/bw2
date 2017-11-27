package dotv3

import (
	"crypto/rand"

	"github.com/syndtr/goleveldb/leveldb"
	"github.com/syndtr/goleveldb/leveldb/util"
)

type Engine struct {
	DB *leveldb.DB
}

func NewEngine() *Engine {
	db, err := leveldb.OpenFile("engine.db", nil)
	if err != nil {
		panic(err)
	}
	return &Engine{
		DB: db,
	}
}
func (e *Engine) Close() {
	e.DB.Close()
}
func (e *Engine) InsertDOT(d *DOTV3) {
	//Key should be namespace+from
	key := []byte{}
	key = append(key, d.Label.Namespace...)
	key = append(key, d.Content.SRCVK...)
	randomness := make([]byte, 16)
	rand.Read(randomness)
	key = append(key, randomness...)
	body, err := d.MarshalMsg(nil)
	if err != nil {
		panic(err)
	}
	e.DB.Put(key, body, nil)
}

func (e *Engine) LookupDOTs(namespace []byte, srcvk []byte) ([]*DOTV3, error) {
	key := []byte{}
	key = append(key, namespace...)
	key = append(key, srcvk...)
	brange := util.BytesPrefix(key)
	rv := []*DOTV3{}
	iter := e.DB.NewIterator(brange, nil)
	for iter.Next() {
		v := &DOTV3{}
		_, err := v.UnmarshalMsg(iter.Value())
		if err != nil {
			panic(err)
		}
		rv = append(rv, v)
	}
	return rv, nil
}
