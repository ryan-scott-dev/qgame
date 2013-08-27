#ifndef QGAME_SCREEN_GRAPH_H
#define QGAME_SCREEN_GRAPH_H

#include <mruby.h>

#include "vertex-buffer.h"

struct graph_object
{
  vertex_buffer_t *buffer;
  GLuint vao;
};

struct graph_data
{
	float x, y;
};

void graph_object_free(mrb_state *mrb, void *p);
struct graph_object* graph_object_get_ptr(mrb_state* mrb, mrb_value value);

void qgame_screen_graph_init(mrb_state* mrb, struct RClass* mrb_qgame_class);

#endif /* QGAME_SCREEN_GRAPH_H */