#include "assets/shader_asset.h"

#include <mruby/string.h>
#include <mruby/variable.h>

#include <glew.h>

#include <stdio.h>
#include <stdlib.h>

#include "utils.h"

GLenum 
shader_type_sym_to_enum(mrb_state* mrb, mrb_sym shader_type) {
  if (shader_type == mrb_intern_cstr(mrb, "vertex"))
    return GL_VERTEX_SHADER;
  if (shader_type == mrb_intern_cstr(mrb, "fragment"))
    return GL_FRAGMENT_SHADER;

  return 0;
}

mrb_value
qgame_shader_asset_load_from_file(mrb_state* mrb, mrb_value self)
{
  mrb_value path;  
  mrb_sym shader_type_sym;
  mrb_get_args(mrb, "nS", &shader_type_sym, &path);

  GLenum shader_type = shader_type_sym_to_enum(mrb, shader_type_sym);

  GLuint shader = glCreateShader(shader_type);
  if(shader == 0) {
    mrb_raisef(mrb, E_RUNTIME_ERROR, "Failed creating shader with type: %i", mrb_fixnum_value(shader_type));
    return self;
  }

  char* shader_source = read_file(mrb_string_value_ptr(mrb, path));
  glShaderSource(shader, 1, (const GLchar**)&shader_source, NULL);
  glCompileShader(shader);
  free(shader_source);

  GLint status;
  glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
  if (status == GL_FALSE) {
      
      GLint infoLogLength;
      glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLogLength);
      char strInfoLog[infoLogLength + 1];
      glGetShaderInfoLog(shader, infoLogLength, NULL, strInfoLog);

      glDeleteShader(shader); shader = NULL;
      mrb_raisef(mrb, E_RUNTIME_ERROR, "Failed compiling shader '%S': %S", path, mrb_str_new_cstr(mrb, &strInfoLog));
      return self;
  }

  mrb_value shader_id = mrb_fixnum_value(shader);
  mrb_iv_set(mrb, self, mrb_intern(mrb, "shader_id"), shader_id);

  return self;
}

void
qgame_shader_asset_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *shader_asset_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "ShaderAsset", mrb->object_class);

  mrb_define_method(mrb, shader_asset_class, "load_from_file", qgame_shader_asset_load_from_file, ARGS_REQ(1));
}