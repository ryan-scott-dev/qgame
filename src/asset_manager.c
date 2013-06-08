#include "asset_manager.h"

#include <tinydir.h>
#include <mruby/string.h>


void
qgame_asset_manager_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *asset_manager_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "AssetManager", mrb->object_class);
}