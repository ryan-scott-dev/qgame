#include "mouse.h"

#include <SDL2/SDL.h>

#include "mrb_vec2.h"

mrb_value
qgame_mouse_position(mrb_state* mrb, mrb_value self)
{
	int x, y;
	if(SDL_GetMouseState(&x, &y)) {
		return wrap_new_vec2(mrb, x, y);
	}

	return mrb_nil_value();
}

void
qgame_mouse_init(mrb_state* mrb) {
  struct RClass *qgame_class = mrb_class_get(mrb, "QGame");
  struct RClass *qgame_mouse_class = mrb_define_class_under(mrb, qgame_class, "Mouse", mrb->object_class);

  mrb_define_module_function(mrb, qgame_mouse_class, "position", qgame_mouse_position, MRB_ARGS_NONE());
}