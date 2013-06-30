#include "assets/texture_asset.h"

#include <mruby/string.h>
#include <mruby/variable.h>

#include "gl_header.h"
#include <SDL2/SDL_image.h>

mrb_value
qgame_texture_asset_load_from_file(mrb_state* mrb, mrb_value self)
{
  GLuint texture;     // This is a handle to our texture object
  SDL_Surface *surface; // This surface will tell us the details of the image
  GLenum texture_format;

  mrb_value path;
  mrb_get_args(mrb, "S", &path);
  char* file = mrb_string_value_ptr(mrb, path);

  if ( (surface = IMG_Load(file)) ) { 
    // Check that the image's width is a power of 2
    if ( (surface->w & (surface->w - 1)) != 0 ) {
      printf("warning: %s's width is not a power of 2\n", file);
    }
   
    // Also check if the height is a power of 2
    if ( (surface->h & (surface->h - 1)) != 0 ) {
      printf("warning: %s's height is not a power of 2\n", file);
    }

    // get the number of channels in the SDL surface
    GLint  nOfColors = surface->format->BytesPerPixel;
    if (nOfColors == 4)     // contains an alpha channel
    {
      if (surface->format->Rmask == 0x000000ff)
        texture_format = GL_RGBA;
      else
        texture_format = GL_BGRA;
    } else if (nOfColors == 3)     // no alpha channel
    {
      if (surface->format->Rmask == 0x000000ff)
        texture_format = GL_RGB;
      else
        texture_format = GL_BGRA;
    } else {
      printf("warning: the image is not truecolor..  this will probably break\n");
    }

    // Have OpenGL generate a texture object handle for us
    glGenTextures( 1, &texture );
   
    // Bind the texture object
    glBindTexture( GL_TEXTURE_2D, texture );
   
    // Set the texture's stretching properties
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
   
    // Edit the texture object's image data using the information SDL_Surface gives us
    glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, surface->w, surface->h, 0,
                        texture_format, GL_UNSIGNED_BYTE, surface->pixels );
    
    GLenum err = glGetError();
    if (err != GL_NO_ERROR) {
      printf("Error loading image into GL: %i\n", err);
    }
    
    mrb_value texture_id = mrb_fixnum_value(texture);
    mrb_iv_set(mrb, self, mrb_intern(mrb, "texture_id"), texture_id);
    
    mrb_value mrb_width = mrb_fixnum_value(surface->w);
    mrb_iv_set(mrb, self, mrb_intern(mrb, "@width"), mrb_width);
  
    mrb_value mrb_height = mrb_fixnum_value(surface->h);
    mrb_iv_set(mrb, self, mrb_intern(mrb, "@height"), mrb_height);
  }
  else {
    printf("SDL could not load image.bmp: %s\n", SDL_GetError());
  }    

  // Free the SDL_Surface only if it was successfully created
  if ( surface ) { 
    SDL_FreeSurface( surface );
  }

  return self;
}

mrb_value
qgame_texture_asset_bind(mrb_state* mrb, mrb_value self)
{
  mrb_value mrb_texture_id = mrb_iv_get(mrb, self, mrb_intern(mrb, "texture_id"));
  GLuint texture_id = mrb_fixnum(mrb_texture_id);
  
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, texture_id);

  return self;
}

mrb_value
qgame_texture_asset_unbind(mrb_state* mrb, mrb_value self)
{
  glBindTexture(GL_TEXTURE_2D, 0);

  return self;
}

void
qgame_texture_asset_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *texture_asset_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "TextureAsset", mrb->object_class);

  mrb_define_method(mrb, texture_asset_class, "load_from_file", qgame_texture_asset_load_from_file, ARGS_REQ(1));
  mrb_define_method(mrb, texture_asset_class, "bind", qgame_texture_asset_bind, ARGS_NONE());
  mrb_define_method(mrb, texture_asset_class, "unbind", qgame_texture_asset_unbind, ARGS_NONE());
}