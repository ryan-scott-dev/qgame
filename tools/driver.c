/*
** mrbtest - Test for Embeddable Ruby
**
** This program runs Ruby test programs in test/t directory
** against the current mruby implementation.
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <mruby.h>
#include <mruby/proc.h>
#include <mruby/data.h>
#include <mruby/compile.h>
#include <mruby/string.h>
#include <mruby/variable.h>

void 
mrb_init_qgamelib(mrb_state *);

void
mrb_init_application(mrb_state *);

void
qgame_init(mrb_state *);

void 
mrb_mruby_sdl_gem_init(mrb_state *);

void 
mrb_init_mrbgems(mrb_state *);

int
main(int argc, char **argv)
{
  mrb_state *mrb;

  /* new interpreter instance */
  mrb = mrb_open();
  if (mrb == NULL) {
    fprintf(stderr, "Invalid mrb_state, exiting test driver");
    return EXIT_FAILURE;
  }
  
  mrb_init_mrbgems(mrb);
  
  qgame_init(mrb);
  mrb_init_qgamelib(mrb);
  
  mrb_init_application(mrb);

  mrb_close(mrb);

  return EXIT_SUCCESS;
}
