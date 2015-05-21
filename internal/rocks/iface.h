
#include <stddef.h>
#include <string.h>
#include <stdlib.h>



const int CF_DOT    = 1;
const int CF_DCHAIN = 2;
const int CF_MSG    = 3;
const int CF_MSG_I  = 4;
const int CF_ENTITY = 5;

void put_object(int cf, const char *key, size_t keylen, const char *value, size_t valuelen);

char *get_object(int cf, const char *key, size_t keylen, size_t *valuelen);
void delete_object(int cf, const char *key, size_t keylen);
void init();
int exists(int cf, const char* key, size_t keylen);
