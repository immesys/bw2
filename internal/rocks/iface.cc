#include <cstdio>
#include <string>

#include "rocksdb/db.h"
#include "rocksdb/slice.h"
#include "rocksdb/options.h"
#include <stdlib.h>

using namespace rocksdb;

std::string persistDBPath = "bw.db";
static DB* persistDB;

std::string cacheDBPath = "bw.cache";
static DB* cacheDB;

void init() 
{
  Options options;
  // Optimize RocksDB. This is the easiest way to get RocksDB to perform well
  options.IncreaseParallelism();
  options.OptimizeLevelStyleCompaction();
  // create the DB if it's not already present
  options.create_if_missing = true;

  // open DB
  Status s = DB::Open(options, persistDBPath, &persistDB);
  assert(s.ok());
  s = DB::Open(options, cacheDBPath, &cacheDB);
  assert(s.ok());

#if 0
  // get value
  s = db->Get(ReadOptions(), "key1", &value);
  assert(s.ok());
  assert(value == "value");

  // atomically apply a set of updates
  {
    WriteBatch batch;
    batch.Delete("key1");
    batch.Put("key2", value);
    s = db->Write(WriteOptions(), &batch);
  }

  s = db->Get(ReadOptions(), "key1", &value);
  assert(s.IsNotFound());

  db->Get(ReadOptions(), "key2", &value);
  assert(value == "value");

  delete db;
#endif
}

void putCacheObject(const char *key, size_t keylen, const char *value, size_t valuelen) 
{
  std::string skey = std::string(key, keylen);
  std::string sval = std::string(value, valuelen);
  // Put key-value
  Status s = cacheDB->Put(WriteOptions(), skey, sval);
  assert(s.ok());
}
void putPersistObject(const char *key, size_t keylen, const char *value, size_t valuelen) 
{
  std::string skey = std::string(key, keylen);
  std::string sval = std::string(value, valuelen);
  // Put key-value
  Status s = persistDB->Put(WriteOptions(), skey, sval);
  assert(s.ok());
}
char *getCacheObject(const char *key, size_t keylen, size_t *valuelen)
{
 std::string skey = std::string(key, keylen);
 std::string value;
 char *rv;
 Status s = cacheDB->Get(ReadOptions(), skey, &value);
 assert(s.ok());
 rv = (char*) malloc(value.length());
 *valuelen = value.length();
 memcpy(rv, value.data(), value.length());
 return rv;
}
