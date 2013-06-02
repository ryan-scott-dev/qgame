#include <stdlib.h>
#include "mruby.h"
#include "mruby/irep.h"
#include "mruby/dump.h"
#include "mruby/string.h"
#include "mruby/proc.h"

extern const uint8_t mrbapp_irep[];

void
mrb_init_application(mrb_state *mrb)
{
  mrb_load_irep(mrb, mrbapp_irep);
  if (mrb->exc) {
    mrb_p(mrb, mrb_obj_value(mrb->exc));
    exit(EXIT_FAILURE);
  }
}

