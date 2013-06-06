#include "application.h"

void
qgame_application_init(mrb_state* mrb) {
  struct RClass *qgame = mrb_class_get(mrb, "QGame");
  // struct RClass *qgame_application = mrb_define_class_under(mrb, qgame, "Application", mrb->object_class);
}