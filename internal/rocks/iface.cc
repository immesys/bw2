#include <cstdio>
#include <string>

#include "rocksdb/db.h"
#include "rocksdb/slice.h"
#include "rocksdb/options.h"
#include <stdlib.h>

using namespace rocksdb;

std::string DBPath = "bw.db";
static DB* db;

extern "C"
{
void init()
{
  Options options;
  // Optimize RocksDB. This is the easiest way to get RocksDB to perform well
  options.IncreaseParallelism();
  options.OptimizeLevelStyleCompaction();
  // create the DB if it's not already present
  options.create_if_missing = true;

  // open DB
  Status s = DB::Open(options, DBPath, &db);
  assert(s.ok());
}

void put_object(const char *key, size_t keylen, const char *value, size_t valuelen)
{
  std::string skey = std::string(key, keylen);
  std::string sval = std::string(value, valuelen);
  // Put key-value
  Status s = db->Put(WriteOptions(), skey, sval);
  assert(s.ok());
}
char *get_object(const char *key, size_t keylen, size_t *valuelen)
{
  std::string skey = std::string(key, keylen);
  std::string value;
  char *rv;
  Status s = db->Get(ReadOptions(), skey, &value);
  if (s.IsNotFound())
  {
    return NULL;
  }
  assert(s.ok());
  rv = (char*) malloc(value.length());
  *valuelen = value.length();
  memcpy(rv, value.data(), value.length());
  return rv;
}
}
