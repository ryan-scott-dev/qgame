#include "assets/sound_asset.h"
#include "mrb_sdl_music.h"

#include <mruby/string.h>
#include <mruby/variable.h>

#include <SDL2/SDL_mixer.h>

mrb_value
qgame_sound_asset_load_from_file(mrb_state* mrb, mrb_value self)
{
  mrb_value path;
  mrb_get_args(mrb, "S", &path);
  char* file = mrb_string_value_ptr(mrb, path);

  Mix_Music *music = NULL;
  
  int audio_rate = 22050;
  Uint16 audio_format = AUDIO_S16; /* 16-bit stereo */
  int audio_channels = 2;
  int audio_buffers = 4096;

  Mix_QuerySpec(&audio_rate, &audio_format, &audio_channels);

  music = Mix_LoadMUS(file);

  // Wrap music in a ruby structure
  mrb_value mrb_music = mrb_sdl_music_wrap(mrb, music);

  mrb_iv_set(mrb, self, mrb_intern(mrb, "sound"), mrb_music);

  return self;
}

void
qgame_sound_asset_init(mrb_state* mrb, struct RClass* mrb_qgame_class) {
  struct RClass *sound_asset_class = mrb_define_class_under(mrb, mrb_qgame_class, 
    "SoundAsset", mrb->object_class);

  mrb_define_method(mrb, sound_asset_class, "load_from_file", qgame_sound_asset_load_from_file, ARGS_REQ(1));
}