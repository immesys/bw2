#include <cstdio>
#include <string>

#include "rocksdb/db.h"
#include "rocksdb/slice.h"
#include "rocksdb/options.h"

#include <stdlib.h>

using namespace rocksdb;

std::string DBPath = ".bw.db";
static DB* db;
std::vector<ColumnFamilyHandle*> handles;

extern "C"
{
  #include "iface.h"
Status openDB()
{
  Options options;
  // Optimize RocksDB. This is the easiest way to get RocksDB to perform well
  options.IncreaseParallelism();
  options.OptimizeLevelStyleCompaction();

  // create column families
  std::vector<ColumnFamilyDescriptor> cfz;
  // have to open default column family
  cfz.push_back(ColumnFamilyDescriptor(kDefaultColumnFamilyName, ColumnFamilyOptions()));
  // open the DOT column family
  cfz.push_back(ColumnFamilyDescriptor("CF_DOT", ColumnFamilyOptions()));
  // open the DCHAIN column family
  cfz.push_back(ColumnFamilyDescriptor("CF_DCHAIN", ColumnFamilyOptions()));
  // open the MSG column family
  cfz.push_back(ColumnFamilyDescriptor("CF_MSG", ColumnFamilyOptions()));
  // open the interlaced MSG column family
  cfz.push_back(ColumnFamilyDescriptor("CF_MSG_I", ColumnFamilyOptions()));
  // open the entity column family
  cfz.push_back(ColumnFamilyDescriptor("CF_ENTITY", ColumnFamilyOptions()));
  Status s = DB::Open(options, DBPath, cfz, &handles, &db);
  return s;
}
void createDB()
{
  Options options;
  //Need to create a DB
  // create the DB if it's not already present
  options.create_if_missing = true;
  Status s = DB::Open(options, DBPath, &db);
  assert(s.ok());
  // create column family
  ColumnFamilyHandle* cf1;
  s = db->CreateColumnFamily(ColumnFamilyOptions(), "CF_DOT", &cf1);
  assert(s.ok());
  // create column family
  ColumnFamilyHandle* cf2;
  s = db->CreateColumnFamily(ColumnFamilyOptions(), "CF_DCHAIN", &cf2);
  assert(s.ok());
  // create column family
  ColumnFamilyHandle* cf3;
  s = db->CreateColumnFamily(ColumnFamilyOptions(), "CF_MSG", &cf3);
  assert(s.ok());
  // create column family
  ColumnFamilyHandle* cf4;
  s = db->CreateColumnFamily(ColumnFamilyOptions(), "CF_MSG_I", &cf4);
  assert(s.ok());
  // create column family
  ColumnFamilyHandle* cf5;
  s = db->CreateColumnFamily(ColumnFamilyOptions(), "CF_ENTITY", &cf5);
  assert(s.ok());
  delete cf1;
  delete cf2;
  delete cf3;
  delete cf4;
  delete cf5;
  delete db;
}
void init()
{
  Status s = openDB();
  if (!s.ok())
  {
    printf("Had to create DB\n");
    createDB();
    s = openDB();
    printf("Status: %s\n", s.ToString().c_str());
  } else {
    printf("FSTATL: %s\n", s.ToString().c_str());
  }
  printf("DB STATUS: %s\n", s.ToString().c_str());
  assert(s.ok());
}

void put_object(int cf, const char *key, size_t keylen, const char *value, size_t valuelen)
{
  //printf("RXPUT cf=%d keylen=%d k0=%d k=%s vl=%d\n", cf, (int)keylen, key[0], key+1, (int)valuelen);
  Status s = db->Put(WriteOptions(), handles[cf], Slice(key, keylen), Slice(value, valuelen));
  assert(s.ok());
}
void delete_object(int cf, const char *key, size_t keylen)
{
  Status s = db->Delete(WriteOptions(), handles[cf], Slice(key, keylen));
}
char *get_object(int cf, const char *key, size_t keylen, size_t *valuelen)
{
  //printf("RXGET cf=%d keylen=%d k0=%d k=%s\n", cf, (int)keylen, key[0], key+1);
  std::string value;
  char *rv;
  Status s = db->Get(ReadOptions(), handles[cf], Slice(key, keylen), &value);
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

int exists(int cf, const char* key, size_t keylen)
{
  //printf("RXEXISTS cf=%d keylen=%d k0=%d k=%s\n", cf, (int)keylen, key[0], key+1);
  std::string value;
  char *rv;
  Status s = db->Get(ReadOptions(), handles[cf], Slice(key, keylen), &value);
  if (s.IsNotFound())
  {
    return 0;
  }
  else if (s.ok())
  {
    return 1;
  }
  assert(0);
}

void iterator_create(int cf, const char* key, size_t keylen, void** state,
    char** okey, size_t* okeylen, char** value, size_t* valuelen)
{
  Iterator* it = db->NewIterator(ReadOptions(), handles[cf]);
  it->Seek(Slice(key, keylen));
  *state = it;
  if (!it->Valid()) {
    *okeylen = 0;
    *valuelen = 0;
  } else {
    *okey = (char*) it->key().data();
    *okeylen = it->key().size();
    *value = (char*) it->value().data();
    *valuelen = it->value().size();
  }
}
void iterator_delete(void* state)
{
  delete (Iterator*)state;
}
void iterator_next(void* state, char** key, size_t* keylen, char** value, size_t* valuelen)
{
  Iterator *it = (Iterator*)state;
  it->Next();
  if (!it->Valid()) {
    *keylen = 0;
    *valuelen = 0;
  } else {
    *key = (char*) it->key().data();
    *keylen = it->key().size();
    *value = (char*) it->value().data();
    *valuelen = it->value().size();
  }
}
}
