#include "assets/model_asset.h"

#include <mruby/string.h>
#include <mruby/variable.h>

#include <glew.h>

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

  char* count_source = strdup(model_source);

  /* Parse the file into a float array */
  char* tokens = strtok(count_source, " ,\n");
  int model_size = 0;
  while (tokens != NULL) {
    model_size++;
    tokens = strtok (NULL, " ,\n");
  }
  free(count_source);
  char* data_source = strdup(model_source);
  
  GLfloat vertexData[model_size];
  int index = 0;
  tokens = strtok(data_source, " ,\n");
  while (tokens != NULL) {
    vertexData[index++] = atof(tokens);
    tokens = strtok (NULL, " ,\n");
  }

  free(data_source);
  free(model_source);

  glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
  int triangle_size = 5;
  mrb_value triangle_count = mrb_fixnum_value(model_size / triangle_size);
  mrb_iv_set(mrb, self, mrb_intern(mrb, "triangle_count"), triangle_count);

  mrb_value vao_id = mrb_fixnum_value(vao);
  mrb_iv_set(mrb, self, mrb_intern(mrb, "vao_id"), vao_id);

  mrb_value vbo_id = mrb_fixnum_value(vbo);
  mrb_iv_set(mrb, self, mrb_intern(mrb, "vbo_id"), vbo_id);
  
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glBindVertexArray(0);

  return self;
}

mrb_value
qgame_model_asset_bind(mrb_state* mrb, mrb_value self)
{
  mrb_value vao_id = mrb_iv_get(mrb, self, mrb_intern(mrb, "vao_id"));
  GLuint vao = mrb_fixnum(vao_id);

  mrb_value vbo_id = mrb_iv_get(mrb, self, mrb_intern(mrb, "vbo_id"));
  GLuint vbo = mrb_fixnum(vbo_id);
  
  glBindBuffer(GL_ARRAY_BUFFER, vbo);
  glBindVertexArray(vao);

  return self;
}

mrb_value
qgame_model_asset_unbind(mrb_state* mrb, mrb_value self)
{
  glBindVertexArray(0);
  glBindBuffer(GL_ARRAY_BUFFER, 0);

  return self;
}

mrb_value
qgame_model_asset_render(mrb_state* mrb, mrb_value self)
{
  mrb_value mrb_triangle_count = mrb_iv_get(mrb, self, mrb_intern(mrb, "triangle_count"));
  int triangle_count = mrb_fixnum(mrb_triangle_count);
  
  glDrawArrays(GL_TRIANGLES, 0, triangle_count);

  return self;
}

void
qgame_model_asset_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *model_asset_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "ModelAsset", mrb->object_class);

  mrb_define_method(mrb, model_asset_class, "load_from_file", qgame_model_asset_load_from_file, ARGS_REQ(1));
  mrb_define_method(mrb, model_asset_class, "render", qgame_model_asset_render, ARGS_NONE());
  mrb_define_method(mrb, model_asset_class, "bind", qgame_model_asset_bind, ARGS_NONE());
  mrb_define_method(mrb, model_asset_class, "unbind", qgame_model_asset_unbind, ARGS_NONE());
}