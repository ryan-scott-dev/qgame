#include "application.h"

void
qgame_application_init(mrb_state* mrb) {
  struct RClass *application = mrb_define_module(mrb, "Application");
}