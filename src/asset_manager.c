#include "asset_manager.h"
#include "dirent.h"

#include <mruby/string.h>

mrb_value
qgame_asset_manager_load(mrb_state* mrb, mrb_value self)
{
  /* Find all of the assets to load */
  DIR *dir;
  struct dirent *ent;

  mrb_value path;
  mrb_get_args(mrb, "S", &path);

  if ((dir = opendir(mrb_string_value_ptr(mrb, path))) != NULL) {
    /* print all the files and directories within directory */
    while ((ent = readdir (dir)) != NULL) {
      printf ("%s\n", ent->d_name);
    }
    closedir (dir);
  } else {
    /* could not open directory */
    perror ("");
    return mrb_nil_value();
  }
  /* Load each one into a hash divide by type and then by name */

  return self;
}

void
qgame_asset_manager_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *asset_manager_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "AssetManager", mrb->object_class);

  mrb_define_module_function(mrb, asset_manager_class, "load", qgame_asset_manager_load, ARGS_REQ(1));
}