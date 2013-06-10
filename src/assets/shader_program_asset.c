#include "assets/shader_program_asset.h"

#include <mruby/string.h>
#include <mruby/variable.h>

#include <glew.h>

mrb_value
qgame_shader_program_asset_link(mrb_state* mrb, mrb_value self)
{
  mrb_value vertex_asset, fragment_asset;  
  
  mrb_get_args(mrb, "oo", &vertex_asset, &fragment_asset);

  GLuint program = glCreateProgram();
  if(program == 0) {
    mrb_raisef(mrb, E_RUNTIME_ERROR, "Failed creating shader program");
    return self;
  }

  mrb_value vertex_shader_id = mrb_iv_get(mrb, vertex_asset, mrb_intern(mrb, "shader_id"));
  GLuint vertex_shader = mrb_fixnum(vertex_shader_id);
  glAttachShader(program, vertex_shader);

  mrb_value fragment_shader_id = mrb_iv_get(mrb, fragment_asset, mrb_intern(mrb, "shader_id"));
  GLuint fragment_shader = mrb_fixnum(fragment_shader_id);
  glAttachShader(program, fragment_shader);

  glLinkProgram(program);

  glDetachShader(program, vertex_shader);
  glDetachShader(program, fragment_shader);

  GLint status;
  glGetProgramiv(program, GL_LINK_STATUS, &status);
  if (status == GL_FALSE) {
      GLint infoLogLength;
      glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLogLength);
      char strInfoLog[infoLogLength + 1];
      glGetProgramInfoLog(program, infoLogLength, NULL, strInfoLog);
      
      glDeleteProgram(program); program = NULL;
      mrb_raisef(mrb, E_RUNTIME_ERROR, "Failed linking shader program: '%S'", mrb_str_new_cstr(mrb, &strInfoLog));
      return self;
  }

  mrb_value program_id = mrb_fixnum_value(program);
  mrb_iv_set(mrb, self, mrb_intern(mrb, "program_id"), program_id);

  return self;
}

mrb_value
qgame_shader_program_asset_bind(mrb_state* mrb, mrb_value self)
{
  mrb_value program_id = mrb_iv_get(mrb, self, mrb_intern(mrb, "program_id"));
  GLuint program = mrb_fixnum(program_id);
  
  glUseProgram(program);

  // connect the xyz to the "vert" attribute of the vertex shader
  GLint attrib = glGetAttribLocation(program, "vert");
  
  glEnableVertexAttribArray(attrib);
  glVertexAttribPointer(attrib, 3, GL_FLOAT, GL_FALSE, 0, NULL);

  return self;
}

mrb_value
qgame_shader_program_asset_unbind(mrb_state* mrb, mrb_value self)
{
  glUseProgram(0);

  return self;
}

void
qgame_shader_program_asset_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *shader_program_asset_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "ShaderProgramAsset", mrb->object_class);

  mrb_define_method(mrb, shader_program_asset_class, "link", qgame_shader_program_asset_link, ARGS_REQ(2));
  mrb_define_method(mrb, shader_program_asset_class, "bind", qgame_shader_program_asset_bind, ARGS_NONE());
  mrb_define_method(mrb, shader_program_asset_class, "unbind", qgame_shader_program_asset_unbind, ARGS_NONE());
}