#include "utils.h"

#include <stdio.h>
#include <stdlib.h>

char* read_file(const char* path) {
  char *source = NULL;
  FILE *fp = fopen(path, "rb");
  if (fp != NULL) {
    /* Go to the end of the file. */
    if (fseek(fp, 0L, SEEK_END) == 0) {
      /* Get the size of the file. */
      long bufsize = ftell(fp);
      if (bufsize == -1) { 
        fputs("Error getting the file size\n", stderr);
      }

      rewind(fp);
      
      /* Allocate our buffer to that size. */
      source = malloc(sizeof(char) * (bufsize + 1));

      /* Read the entire file into memory. */
      size_t newLen = fread(source, sizeof(char), bufsize, fp);
      if (newLen == 0) {
        fputs("Error reading file\n", stderr);
      } else {
        source[newLen] = '\0'; /* Just to be safe. */
      }
    }
    fclose(fp);
  }

  return source;
}