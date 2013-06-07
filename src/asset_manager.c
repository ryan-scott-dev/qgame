#include "asset_manager.h"

#include <tinydir.h>
#include <mruby/string.h>

void listdir(const char *name, int level)
{
    DIR *dir;
    struct dirent *entry;

    if (!(dir = opendir(name)))
        return;
    if (!(entry = readdir(dir)))
        return;

    do {
        if (entry->d_type == DT_DIR) {
            char path[1024];
            int len = snprintf(path, sizeof(path)-1, "%s/%s", name, entry->d_name);
            path[len] = 0;
            if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
                continue;
            printf("%*s[%s]\n", level*2, "", entry->d_name);
            listdir(path, level + 1);
        }
        else
            printf("%*s- %s\n", level*2, "", entry->d_name);
    } while (entry = readdir(dir));
    closedir(dir);
}

void tiny_listdir(const char *name, int level)
{
    tinydir_dir dir;
    
    if (tinydir_open(&dir, name) == -1)
    {
      perror("Error opening file");
    }

    while (dir.has_next) {
        tinydir_file file;
        tinydir_readfile(&dir, &file);
        
        if (file.is_dir) {
            char path[1024];
            int len = snprintf(path, sizeof(path)-1, "%s/%s", name, file.name);
            path[len] = 0;
            if (strcmp(file.name, ".") != 0 && strcmp(file.name, "..") != 0) {
              printf("%*s[%s]\n", level*2, "", file.name);
              tiny_listdir(path, level + 1);
            }
        }
        else
            printf("%*s- %s\n", level*2, "", file.name);

        tinydir_next(&dir);
    } 
    tinydir_close(&dir);
}

mrb_value
qgame_asset_manager_load(mrb_state* mrb, mrb_value self)
{
  // listdir("./assets", 0);
  tiny_listdir("./assets", 0);

  /* Find all of the assets to load */

  /* Load each one into a hash divide by type and then by name */

  return self;
}

void
qgame_asset_manager_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *asset_manager_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "AssetManager", mrb->object_class);

  mrb_define_module_function(mrb, asset_manager_class, "load", qgame_asset_manager_load, ARGS_NONE());
}