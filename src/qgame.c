#include "qgame.h"
#include "application.h"

void
qgame_init(mrb_state* mrb) {
  struct RClass *qgame = mrb_define_module(mrb, "QGame");

  qgame_application_init(mrb);
}