
#include <stddef.h>
#include <string.h>
#include <stdlib.h>

void put_object(const char *key, size_t keylen, const char *value, size_t valuelen);

char *get_object(const char *key, size_t keylen, size_t *valuelen);

void init();
