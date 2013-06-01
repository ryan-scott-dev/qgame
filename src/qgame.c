#include "qgame.h"
#include "application.h"
#include "mrb_sdl.h"

void
qgame_init(mrb_state* mrb) {
  struct RClass *qgame = mrb_define_module(mrb, "QGame");

  mrb_mruby_sdl_gem_init(mrb);
  qgame_application_init(mrb);
}