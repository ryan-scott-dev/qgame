#include "screens/graph.h"

#include <mruby/data.h>

/* Render */

/* Add value to graph */

/* Set graph values from array */

/* Set size of graph */

static struct RClass* qgame_graph_object_class = NULL;

struct mrb_data_type graph_object_type = { "GraphObject", graph_object_free };

struct graph_object* 
allocate_new_graph_object(mrb_state* mrb) {
	struct graph_object* new_graph_object = (struct graph_object *)mrb_malloc(mrb, sizeof(struct graph_object));
	new_graph_object->data = vector_new(sizeof(struct graph_data));
  return new_graph_object; 
}

void 
graph_object_free(mrb_state *mrb, void *ptr) {
	struct graph_object* object = ((struct graph_object*)ptr);

	vector_delete(object->data);
  mrb_free(mrb, ptr);
}

mrb_value 
qgame_graph_object_initialize(mrb_state *mrb, mrb_value self) {
  struct graph_object *tm;

  tm = (struct graph_object*)DATA_PTR(self);
  if (tm) {
    graph_object_free(mrb, tm);
  }
  DATA_TYPE(self) = &graph_object_type;
  DATA_PTR(self) = allocate_new_graph_object(mrb);
  return self;
}

mrb_value
qgame_graph_object_push_value(mrb_state *mrb, mrb_value self) {
	return self;
}

void
qgame_screen_graph_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
	qgame_graph_object_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "GraphObject", mrb->object_class);

	mrb_define_method(mrb, qgame_graph_object_class, "initialize", qgame_graph_object_initialize, ARGS_NONE());
	mrb_define_method(mrb, qgame_graph_object_class, "push_value", qgame_graph_object_push_value, ARGS_REQ(2));
}
