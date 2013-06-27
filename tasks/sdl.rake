require 'fileutils'

current_dir = Dir.pwd

namespace :sdl do
  def download_file(url, path)
    FileUtils.sh "curl -o #{path} #{url}"
  end

  DEPENDENCIES_DIR = "#{QGAME_ROOT}/dependencies"
  SDL_URL = 'http://www.libsdl.org/tmp/release/SDL2-2.0.0.tar.gz'
  SDL_CLONE_DIR = "#{DEPENDENCIES_DIR}/SDL2-2.0.0.tar.gz"
  SDL_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL2-2.0.0"

  SDL_IMAGE_URL = 'http://www.libsdl.org/tmp/SDL_image/release/SDL2_image-2.0.0.tar.gz'
  SDL_IMAGE_CLONE_DIR = "#{DEPENDENCIES_DIR}/SDL2_image-2.0.0.tar.gz"
  SDL_IMAGE_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL2_image-2.0.0"

  SDL_MIXER_URL = 'http://www.libsdl.org/tmp/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz'
  SDL_MIXER_CLONE_DIR = "#{DEPENDENCIES_DIR}/SDL2_mixer-2.0.0.tar.gz"
  SDL_MIXER_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL2_mixer-2.0.0"

  SDL_HOST_OUTPUT = "#{DEPENDENCIES_DIR}/SDL2/host/lib/libSDL2.a"

  libs = []

  Game.each_target do |t|
    OUTPUT_DIR = "#{DEPENDENCIES_DIR}/SDL2/#{t.name}"

    SDL_OUTPUT_FILE = t.libfile("#{OUTPUT_DIR}/lib/libSDL2")
    SDL_IMAGE_OUTPUT_FILE = t.libfile("#{OUTPUT_DIR}/lib/libSDL2_image")
    SDL_MIXER_OUTPUT_FILE = t.libfile("#{OUTPUT_DIR}/lib/libSDL2_mixer")
    libs << SDL_OUTPUT_FILE
    libs << SDL_IMAGE_OUTPUT_FILE
    libs << SDL_MIXER_OUTPUT_FILE
    
    file SDL_CLONE_DIR do |t|
      download_file(SDL_URL, SDL_CLONE_DIR)  
    end
    
    file SDL_IMAGE_CLONE_DIR do |t|
      download_file(SDL_IMAGE_URL, SDL_IMAGE_CLONE_DIR)  
    end
    
    file SDL_CLONE_DIR do |t|
      download_file(SDL_MIXER_URL, SDL_CLONE_DIR)  
    end

    directory SDL_EXTRACTED_DIR => SDL_CLONE_DIR do |t|
      FileUtils.sh "tar -C #{DEPENDENCIES_DIR} -zxf #{SDL_CLONE_DIR}"
    end

    directory SDL_IMAGE_EXTRACTED_DIR => SDL_IMAGE_CLONE_DIR do |t|
      FileUtils.sh "tar -C #{DEPENDENCIES_DIR} -zxf #{SDL_IMAGE_CLONE_DIR}"
    end

    directory SDL_MIXER_EXTRACTED_DIR => SDL_MIXER_CLONE_DIR do |t|
      FileUtils.sh "tar -C #{DEPENDENCIES_DIR} -zxf #{SDL_MIXER_CLONE_DIR}"
    end
    
    file SDL_OUTPUT_FILE => SDL_EXTRACTED_DIR do |t|
      FileUtils.cd SDL_EXTRACTED_DIR
      FileUtils.sh "./configure --prefix=#{OUTPUT_DIR}"
      FileUtils.sh 'make'
      FileUtils.sh 'make install'
      FileUtils.cd current_dir
    end

    file SDL_IMAGE_OUTPUT_FILE => [SDL_OUTPUT_FILE, SDL_IMAGE_EXTRACTED_DIR] do |t|
      FileUtils.cd SDL_IMAGE_EXTRACTED_DIR
      FileUtils.sh "./configure --disable-sdltest --prefix=#{OUTPUT_DIR} --with-sdl-prefix=#{OUTPUT_DIR}"
      FileUtils.sh 'make'
      FileUtils.sh 'make install'
      FileUtils.cd current_dir
    end

    file SDL_MIXER_OUTPUT_FILE => [SDL_OUTPUT_FILE, SDL_MIXER_EXTRACTED_DIR] do |t|
      FileUtils.cd SDL_MIXER_EXTRACTED_DIR
      FileUtils.sh "./configure --disable-sdltest --prefix=#{OUTPUT_DIR} --with-sdl-prefix=#{OUTPUT_DIR}"
      FileUtils.sh 'make'
      FileUtils.sh 'make install'
      FileUtils.cd current_dir
    end
  end

  task :compile => libs do
  end
end