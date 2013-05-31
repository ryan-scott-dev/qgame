#include "application.h"

mrb_value
qgame_application_run(mrb_state *mrb, mrb_value self) {
  return self;
}

void
qgame_application_init(mrb_state* mrb) {
  struct RClass *qgame = mrb_class_get(mrb, "QGame");
  struct RClass *qgame_application = mrb_define_class_under(mrb, qgame, "Application", NULL);
  mrb_define_method(mrb, qgame_application, "run", qgame_application_run, MRB_ARGS_NONE());
}