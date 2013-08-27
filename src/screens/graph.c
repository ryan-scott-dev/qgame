#include "screens/graph.h"

#include <mruby/variable.h>
#include <mruby/class.h>
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
	new_graph_object->data = vector_new(sizeof(struct graph_data)); /* Giving bad addresses? */
  return new_graph_object; 
}

void 
graph_object_free(mrb_state *mrb, void *ptr) {
	struct graph_object* object = ((struct graph_object*)ptr);

	vector_delete(object->data);
  mrb_free(mrb, ptr);
}

struct graph_object*
graph_object_get_ptr(mrb_state *mrb, mrb_value value) {
	return DATA_CHECK_GET_PTR(mrb, value, &graph_object_type, struct graph_object);
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
	mrb_float x_value, y_value;
  mrb_get_args(mrb, "ff", &x_value, &y_value);

  struct graph_data new_data;
  new_data.x = x_value;
  new_data.y = y_value;

  struct graph_object* graph = graph_object_get_ptr(mrb, self);
  
  vector_push_back(graph->data, &new_data);

	return self;
}

void
qgame_screen_graph_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
	qgame_graph_object_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "GraphObject", mrb->object_class);
  MRB_SET_INSTANCE_TT(qgame_graph_object_class, MRB_TT_DATA);

	mrb_define_method(mrb, qgame_graph_object_class, "initialize", qgame_graph_object_initialize, ARGS_NONE());
	mrb_define_method(mrb, qgame_graph_object_class, "push_value", qgame_graph_object_push_value, ARGS_REQ(2));
}
