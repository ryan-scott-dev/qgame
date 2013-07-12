#include "qgame.h"

#include "mrb_sdl.h"
#include "mrb_dir.h"
#include "mrb_gmath.h"

#include "application.h"
#include "mouse.h"
#include "asset_manager.h"
#include "assets/shader_asset.h"
#include "assets/model_asset.h"
#include "assets/texture_asset.h"
#include "assets/sound_asset.h"
#include "assets/shader_program_asset.h"

void
qgame_init(mrb_state* mrb) {
  struct RClass *qgame = mrb_define_module(mrb, "QGame");

  mrb_mruby_sdl_gem_init(mrb);
  mrb_mruby_dir_gem_init(mrb);
  mrb_mruby_gmath_gem_init(mrb);

  qgame_application_init(mrb);
  qgame_mouse_init(mrb);
  qgame_asset_manager_init(mrb, qgame);
  qgame_shader_asset_init(mrb, qgame);
  qgame_model_asset_init(mrb, qgame);
  qgame_texture_asset_init(mrb, qgame);
  qgame_sound_asset_init(mrb, qgame);
  qgame_shader_program_asset_init(mrb, qgame);
}