#include "mruby.h"
#include "mruby/irep.h"
#include "mruby/dump.h"
#include "mruby/string.h"
#include "mruby/proc.h"

extern const uint8_t mrbqgamelib_irep[];

void
mrb_init_qgamelib(mrb_state *mrb)
{
  mrb_load_irep(mrb, mrbqgamelib_irep);
}
