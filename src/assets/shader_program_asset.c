#include "assets/shader_program_asset.h"

#include <mruby/string.h>
#include <mruby/variable.h>

#include "mrb_vec2.h"
#include "mrb_vec3.h"
#include "mrb_vec4.h"
#include "mrb_mat4.h"

#include "gl_header.h"

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
  mrb_iv_set(mrb, self, mrb_intern(mrb, "@program_id"), program_id);

  return self;
}

mrb_value
qgame_shader_program_asset_bind(mrb_state* mrb, mrb_value self)
{
  mrb_value program_id = mrb_iv_get(mrb, self, mrb_intern(mrb, "@program_id"));
  GLuint program = mrb_fixnum(program_id);
  
  glUseProgram(program);

  // connect the xyz to the "vert" attribute of the vertex shader
  GLint attrib = glGetAttribLocation(program, "vert");  
  glEnableVertexAttribArray(attrib);
  glVertexAttribPointer(attrib, 3, GL_FLOAT, GL_FALSE, 5*sizeof(GLfloat), NULL);

  GLint attribTex = glGetAttribLocation(program, "vertTexCoord");  
  glEnableVertexAttribArray(attribTex);
  glVertexAttribPointer(attribTex, 2, GL_FLOAT, GL_TRUE, 5*sizeof(GLfloat), (const GLvoid*)(3 * sizeof(GLfloat)));

  return self;
}

mrb_value
qgame_shader_program_asset_unbind(mrb_state* mrb, mrb_value self)
{
  glUseProgram(0);

  return self;
}

mrb_value
qgame_shader_program_asset_find_uniform_location(mrb_state* mrb, mrb_value self)
{
  mrb_value program_id = mrb_iv_get(mrb, self, mrb_intern(mrb, "@program_id"));
  GLuint program = mrb_fixnum(program_id);

  mrb_value mrb_uniform_name;
  mrb_get_args(mrb, "S", &mrb_uniform_name);
  char* uniform_name = mrb_string_value_ptr(mrb, mrb_uniform_name);

  GLint uniform_id = glGetUniformLocation(program, uniform_name);
  if(uniform_id == -1) {
    printf("Program uniform not found: %s\n", uniform_name);
    return self;
  }
  
  return mrb_fixnum_value(uniform_id);
};

mrb_value
qgame_shader_program_asset_set_uniform_fixnum(mrb_state* mrb, mrb_value self)
{
  mrb_int uniform_id;
  mrb_int value;
  mrb_get_args(mrb, "ii", &uniform_id, &value);
  
  glUniform1i(uniform_id, value);

  return self;
}

mrb_value
qgame_shader_program_asset_set_uniform_float(mrb_state* mrb, mrb_value self)
{
  mrb_int uniform_id;
  mrb_float value;
  mrb_get_args(mrb, "if", &uniform_id, &value);
  
  glUniform1f(uniform_id, value);

  return self;
}

mrb_value
qgame_shader_program_asset_set_uniform_vec2(mrb_state* mrb, mrb_value self)
{
  mrb_int uniform_id;
  mrb_value value;
  mrb_get_args(mrb, "io", &uniform_id, &value);
  
  struct vec2* vector = vec2_get_ptr(mrb, value);
  glUniform2fv(uniform_id, 1, vector);

  return self;
}

mrb_value
qgame_shader_program_asset_set_uniform_vec3(mrb_state* mrb, mrb_value self)
{
  mrb_int uniform_id;
  mrb_value value;
  mrb_get_args(mrb, "io", &uniform_id, &value);
  
  struct vec3* vector = vec3_get_ptr(mrb, value);
  glUniform3fv(uniform_id, 1, vector);

  return self;
}

mrb_value
qgame_shader_program_asset_set_uniform_vec4(mrb_state* mrb, mrb_value self)
{
  mrb_int uniform_id;
  mrb_value value;
  mrb_get_args(mrb, "io", &uniform_id, &value);
  
  struct vec4* vector = vec4_get_ptr(mrb, value);
  glUniform4fv(uniform_id, 1, vector);

  return self;
}

mrb_value
qgame_shader_program_asset_set_uniform_mat4(mrb_state* mrb, mrb_value self)
{
  mrb_int uniform_id;
  mrb_value value;
  mrb_get_args(mrb, "io", &uniform_id, &value);

  struct mat4* matrix = mat4_get_ptr(mrb, value);
  glUniformMatrix4fv(uniform_id, 1, GL_FALSE, matrix);

  return self;
}

void
qgame_shader_program_asset_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *shader_program_asset_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "ShaderProgramAsset", mrb->object_class);

  mrb_define_method(mrb, shader_program_asset_class, "link", qgame_shader_program_asset_link, ARGS_REQ(2));
  mrb_define_method(mrb, shader_program_asset_class, "bind", qgame_shader_program_asset_bind, ARGS_NONE());
  mrb_define_method(mrb, shader_program_asset_class, "unbind", qgame_shader_program_asset_unbind, ARGS_NONE());
  mrb_define_method(mrb, shader_program_asset_class, "find_uniform_location", qgame_shader_program_asset_find_uniform_location, ARGS_REQ(1));

  mrb_define_method(mrb, shader_program_asset_class, "set_uniform_fixnum", qgame_shader_program_asset_set_uniform_fixnum, ARGS_REQ(2));
  mrb_define_method(mrb, shader_program_asset_class, "set_uniform_float", qgame_shader_program_asset_set_uniform_float, ARGS_REQ(2));
  mrb_define_method(mrb, shader_program_asset_class, "set_uniform_mat4", qgame_shader_program_asset_set_uniform_mat4, ARGS_REQ(2));
  mrb_define_method(mrb, shader_program_asset_class, "set_uniform_vec2", qgame_shader_program_asset_set_uniform_vec2, ARGS_REQ(2));
  mrb_define_method(mrb, shader_program_asset_class, "set_uniform_vec3", qgame_shader_program_asset_set_uniform_vec3, ARGS_REQ(2));
  mrb_define_method(mrb, shader_program_asset_class, "set_uniform_vec4", qgame_shader_program_asset_set_uniform_vec4, ARGS_REQ(2));
}