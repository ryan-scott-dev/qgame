
#include "mruby.h"

mrb_value 
mrb_game_reload_file(mrb_state* mrb, mrb_value self)
{
	return self;
}

void
mrb_game_reload_gem_init(mrb_state* mrb)
{
	struct RClass* mrb_game_class = mrb_class_get(mrb, "Game");
	mrb_define_module_function(mrb, mrb_game_class, "reload_file", mrb_game_reload_file, MRB_ARGS_NONE());
}

void
mrb_game_reload_gem_final(mrb_state* mrb)
{
}
