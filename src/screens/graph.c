#include "screens/graph.h"

/* Render */

/* Add value to graph */

/* Set graph values from array */

/* Set size of graph */

void
qgame_screen_graph_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
	struct RClass *graph_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    	"Graph", mrb->object_class);
}
