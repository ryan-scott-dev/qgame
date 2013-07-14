#ifndef QGAME_MODEL_ASSET_H
#define QGAME_MODEL_ASSET_H

#include <mruby.h>

#include "gl_header.h"

struct model_asset
{
  GLuint vao, vbo;
  int triangle_count;
};

void model_asset_free(mrb_state *mrb, void *p);

mrb_value model_asset_wrap(mrb_state *mrb, struct RClass *tc, struct model_asset* tm);
struct model_asset* model_asset_get_ptr(mrb_state* mrb, mrb_value value);

void qgame_model_asset_init(mrb_state* mrb, struct RClass* mrb_qgame_class);

#endif /* QGAME_MODEL_ASSET_H */