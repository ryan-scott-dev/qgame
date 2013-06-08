#include "qgame.h"

#include "mrb_sdl.h"
#include "mrb_dir.h"

#include "application.h"
#include "asset_manager.h"

void
qgame_init(mrb_state* mrb) {
  struct RClass *qgame = mrb_define_module(mrb, "QGame");

  mrb_mruby_sdl_gem_init(mrb);
  mrb_mruby_dir_gem_init(mrb);
  qgame_application_init(mrb);
  qgame_asset_manager_init(mrb, qgame);
}