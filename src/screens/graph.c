#include "screens/graph.h"

#include <mruby/variable.h>
#include <mruby/class.h>
#include <mruby/data.h>

static struct RClass* qgame_graph_object_class = NULL;

struct mrb_data_type graph_object_type = { "GraphObject", graph_object_free };

struct graph_object* 
allocate_new_graph_object(mrb_state* mrb) {
	struct graph_object* new_graph_object = (struct graph_object *)mrb_malloc(mrb, sizeof(struct graph_object));
	
	GLuint vao = 0;
  
  glGenVertexArrays(1, &vao);
  glBindVertexArray(vao);

  new_graph_object->vao = vao;
	new_graph_object->buffer = vertex_buffer_new( "vertex:2f" );

	glBindVertexArray(0);

  return new_graph_object; 
}

void 
graph_object_free(mrb_state *mrb, void *ptr) {
	struct graph_object* object = ((struct graph_object*)ptr);

	vertex_buffer_delete(object->buffer);
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
  	
  vertex_buffer_push_back_vertices( graph->buffer, &new_data, 1 );

	return self;
}


mrb_value
qgame_graph_object_bind(mrb_state *mrb, mrb_value self)
{
  struct graph_object* graph = graph_object_get_ptr(mrb, self);

  mrb_int program_id;
  int arg_count = mrb_get_args(mrb, "i", &program_id);

  vertex_buffer_render_setup( graph->buffer, GL_LINE_STRIP );
  
  glBindVertexArray(graph->vao);

  if (arg_count > 0) {
    glUseProgram(program_id);

    // connect the xyz to the "vert" attribute of the vertex shader
    GLint attrib = glGetAttribLocation(program_id, "vertex");  
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 2, GL_FLOAT, GL_FALSE, 2*sizeof(GLfloat), NULL);

  }
  
  return self;
}

mrb_value
qgame_graph_object_unbind(mrb_state *mrb, mrb_value self)
{
  struct graph_object* graph = graph_object_get_ptr(mrb, self);
  
  glUseProgram(0);
  glBindVertexArray(0);
  vertex_buffer_render_finish(graph->buffer);
  glBindTexture(GL_TEXTURE_2D, 0);

  return self;
}

mrb_value
qgame_graph_object_render(mrb_state *mrb, mrb_value self)
{
  struct graph_object* graph = graph_object_get_ptr(mrb, self);

  size_t vcount = graph->buffer->vertices->size;
  
  glDrawArrays( GL_LINE_STRIP, 0, vcount );
 	
  return self;
}

void
qgame_screen_graph_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
	qgame_graph_object_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "GraphObject", mrb->object_class);
  MRB_SET_INSTANCE_TT(qgame_graph_object_class, MRB_TT_DATA);

	mrb_define_method(mrb, qgame_graph_object_class, "initialize", qgame_graph_object_initialize, ARGS_NONE());
	mrb_define_method(mrb, qgame_graph_object_class, "push_value", qgame_graph_object_push_value, ARGS_REQ(2));

  mrb_define_method(mrb, qgame_graph_object_class, "bind", qgame_graph_object_bind, ARGS_REQ(1));
  mrb_define_method(mrb, qgame_graph_object_class, "unbind", qgame_graph_object_unbind, ARGS_NONE());

  mrb_define_method(mrb, qgame_graph_object_class, "render", qgame_graph_object_render, ARGS_NONE());
}
