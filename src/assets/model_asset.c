#include "assets/model_asset.h"

#include <mruby/string.h>
#include <mruby/variable.h>
#include <mruby/class.h>
#include <mruby/data.h>

#include <stdlib.h>
#include <string.h>

#include "utils.h"

static struct RClass* qgame_model_asset_class = NULL;

struct mrb_data_type model_asset_type = { "ModelAsset", model_asset_free };

struct model_asset* 
allocate_new_model_asset(mrb_state* mrb) {
  return (struct model_asset *)mrb_malloc(mrb, sizeof(struct model_asset)); 
}

void 
model_asset_free(mrb_state *mrb, void *ptr)
{
  mrb_free(mrb, ptr);
}

mrb_value 
model_asset_wrap(mrb_state *mrb, struct RClass *tc, struct model_asset* tm)
{
  return mrb_obj_value(Data_Wrap_Struct(mrb, tc, &model_asset_type, tm));
}

struct model_asset*
model_asset_get_ptr(mrb_state* mrb, mrb_value value)
{
  return (struct model_asset*)mrb_data_get_ptr(mrb, value, &model_asset_type);
}


mrb_value 
qgame_model_asset_initialize(mrb_state *mrb, mrb_value self)
{
  struct model_asset *tm;

  tm = (struct model_asset*)DATA_PTR(self);
  if (tm) {
    model_asset_free(mrb, tm);
  }
  DATA_TYPE(self) = &model_asset_type;
  DATA_PTR(self) = NULL;

  tm = allocate_new_model_asset(mrb);
  
  DATA_PTR(self) = tm;
  return self;
}

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
  qgame_model_asset_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "ModelAsset", mrb->object_class);

  mrb_define_method(mrb, qgame_model_asset_class, "load_from_file", qgame_model_asset_load_from_file, ARGS_REQ(1));
  mrb_define_method(mrb, qgame_model_asset_class, "render", qgame_model_asset_render, ARGS_NONE());
  mrb_define_method(mrb, qgame_model_asset_class, "bind", qgame_model_asset_bind, ARGS_NONE());
  mrb_define_method(mrb, qgame_model_asset_class, "unbind", qgame_model_asset_unbind, ARGS_NONE());

  mrb_define_method(mrb, qgame_model_asset_class, "initialize", qgame_model_asset_initialize, ARGS_NONE());
}