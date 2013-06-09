#include "assets/model_asset.h"

#include <mruby/string.h>
#include <mruby/variable.h>

#include <glew.h>
#include <SDL2/SDL_opengl.h>

#include <stdlib.h>
#include <string.h>

#include "utils.h"

mrb_value
qgame_model_asset_load_from_file(mrb_state* mrb, mrb_value self)
{
  mrb_value path;
  mrb_get_args(mrb, "S", &path);
  GLuint vao = 0;
  GLuint vbo = 0;

  glGenVertexArrays(1, &vao);
  glBindVertexArray(vao);

  glGenBuffers(1, &vbo);
  glBindBuffer(GL_ARRAY_BUFFER, vbo);

  char *model_source = read_file(mrb_string_value_ptr(mrb, path));

  /* Parse the file into a float array */
  char* tokens = strtok(model_source, " ,\n");
  int model_size = 0;
  while (tokens != NULL) {
    model_size++;
    tokens = strtok (NULL, " ,\n");
  }

  GLfloat vertexData[model_size];
  int index = 0;
  tokens = strtok(model_source, " ,\n");
  while (tokens != NULL) {
    vertexData[index++] = atof(tokens);
    tokens = strtok (NULL, " ,\n");
  }

  free(model_source);
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);

  mrb_value vao_id = mrb_fixnum_value(vao);
  mrb_iv_set(mrb, self, mrb_intern(mrb, "vao_id"), vao_id);

  mrb_value vbo_id = mrb_fixnum_value(vbo);
  mrb_iv_set(mrb, self, mrb_intern(mrb, "vbo_id"), vbo_id);
  
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glBindVertexArray(0);

  return self;
}

void
qgame_model_asset_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *model_asset_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "ModelAsset", mrb->object_class);

  mrb_define_method(mrb, model_asset_class, "load_from_file", qgame_model_asset_load_from_file, ARGS_REQ(1));
}