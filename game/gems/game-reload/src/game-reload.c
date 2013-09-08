
#include <mruby.h>
#include <mruby/string.h>
#include <mruby/compile.h>

mrb_value 
mrb_game_reload_file(mrb_state* mrb, mrb_value self)
{
  mrb_value path;
  mrb_get_args(mrb, "S", &path);

  char* file_path = mrb_string_value_ptr(mrb, path);

  FILE* file = fopen(file_path, "r");
  if (file == NULL) {
    printf("Error opening file: %s\n", file_path);
    return self;
  }

  mrb_load_file(mrb,file);

  fclose(file);

  return self;
}

void
mrb_game_reload_gem_init(mrb_state* mrb)
{
  struct RClass* mrb_game_class = mrb_class_get(mrb, "Game");
  mrb_define_module_function(mrb, mrb_game_class, "reload_file", mrb_game_reload_file, MRB_ARGS_REQ(1));
}

void
mrb_game_reload_gem_final(mrb_state* mrb)
{
}
