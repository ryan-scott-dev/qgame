require 'fileutils'

current_dir = Dir.pwd

namespace :sdl do
  def download_file(url, path)
    FileUtils.sh "curl -o #{path} #{url}"
  end

  DEPENDENCIES_DIR = "#{QGAME_ROOT}/dependencies"
  SDL_URL = 'http://www.libsdl.org/tmp/release/SDL2-2.0.0.tar.gz'
  SDL_CLONE_DIR = "#{DEPENDENCIES_DIR}/SDL2-2.0.0.tar.gz"
  SDL_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL"

  SDL_IMAGE_URL = 'http://www.libsdl.org/tmp/SDL_image/release/SDL2_image-2.0.0.tar.gz'
  SDL_IMAGE_CLONE_DIR = "#{DEPENDENCIES_DIR}/SDL2_image-2.0.0.tar.gz"
  SDL_IMAGE_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL_image"

  SDL_MIXER_URL = 'http://www.libsdl.org/tmp/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz'
  SDL_MIXER_CLONE_DIR = "#{DEPENDENCIES_DIR}/SDL2_mixer-2.0.0.tar.gz"
  SDL_MIXER_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL_mixer"

  SDL_HOST_OUTPUT = "#{DEPENDENCIES_DIR}/SDL2/host/lib/libSDL2.a"

  libs = []

  QGame.each_target do |target|
    output_dir = "#{DEPENDENCIES_DIR}/SDL2/#{target.name}"

    sdl_output_file = target.libfile("#{output_dir}/lib/libSDL2")
    sdl_image_output_file = target.libfile("#{output_dir}/lib/libSDL2_image")
    sdl_mixer_output_file = target.libfile("#{output_dir}/lib/libSDL2_mixer")
    libs << sdl_output_file
    libs << sdl_image_output_file
    libs << sdl_mixer_output_file
    
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
      FileUtils.mv "#{DEPENDENCIES_DIR}/SDL2-2.0.0", SDL_EXTRACTED_DIR
    end

    directory SDL_IMAGE_EXTRACTED_DIR => SDL_IMAGE_CLONE_DIR do |t|
      FileUtils.sh "tar -C #{DEPENDENCIES_DIR} -zxf #{SDL_IMAGE_CLONE_DIR}"
      FileUtils.mv "#{DEPENDENCIES_DIR}/SDL2_image-2.0.0", SDL_IMAGE_EXTRACTED_DIR
    end

    directory SDL_MIXER_EXTRACTED_DIR => SDL_MIXER_CLONE_DIR do |t|
      FileUtils.sh "tar -C #{DEPENDENCIES_DIR} -zxf #{SDL_MIXER_CLONE_DIR}"
      FileUtils.mv "#{DEPENDENCIES_DIR}/SDL2_mixer-2.0.0", SDL_MIXER_EXTRACTED_DIR
    end
    
    file sdl_output_file => SDL_EXTRACTED_DIR do |t|
      target.build_sdl(directory: SDL_EXTRACTED_DIR, 
        current_dir: current_dir, output_dir: output_dir, library: target.libfile("libSDL2"), 
        output_file: sdl_output_file, target: target)
    end

    file sdl_image_output_file => [sdl_output_file, SDL_IMAGE_EXTRACTED_DIR] do |t|
      target.build_sdl_library(directory: SDL_IMAGE_EXTRACTED_DIR, 
        current_dir: current_dir, output_dir: output_dir, library: target.libfile("libSDL2_image"), 
        output_file: sdl_image_output_file, target: target)
    end

    file sdl_mixer_output_file => [sdl_output_file, SDL_MIXER_EXTRACTED_DIR] do |t|
      target.build_sdl_library(directory: SDL_MIXER_EXTRACTED_DIR, 
        current_dir: current_dir, output_dir: output_dir, library: target.libfile("libSDL2_mixer"), 
        output_file: sdl_mixer_output_file, target: target)
    end
  end

  task :compile => libs do
  end

  sdl_output_dir = "#{DEPENDENCIES_DIR}/SDL2"
  sdl_lib_name = 'libSDL2'

  task :ios_compile_sdl => ["#{sdl_output_dir}/ios_arm/lib/#{sdl_lib_name}.a", "#{sdl_output_dir}/ios_i386/lib/#{sdl_lib_name}.a"] do
    FileUtils.mkdir_p "#{sdl_output_dir}/ios/lib"
    FileUtils.cp_r "#{sdl_output_dir}/ios_arm/include", "#{sdl_output_dir}/ios"
    
    FileUtils.sh "lipo -create -output #{sdl_output_dir}/ios/lib/#{sdl_lib_name}.a #{sdl_output_dir}/ios_arm/lib/#{sdl_lib_name}.a #{sdl_output_dir}/ios_i386/lib/#{sdl_lib_name}.a"
  end

  sdl_image_lib_name = 'libSDL2_image'

  task :ios_compile_sdl_image => ["#{sdl_output_dir}/ios_arm/lib/#{sdl_image_lib_name}.a", "#{sdl_output_dir}/ios_i386/lib/#{sdl_image_lib_name}.a"] do
    FileUtils.mkdir_p "#{sdl_output_dir}/ios/lib"
    FileUtils.sh "lipo -create -output #{sdl_output_dir}/ios/lib/#{sdl_image_lib_name}.a #{sdl_output_dir}/ios_arm/lib/#{sdl_image_lib_name}.a #{sdl_output_dir}/ios_i386/lib/#{sdl_image_lib_name}.a"
  end

  sdl_mixer_lib_name = 'libSDL2_mixer'

  task :ios_compile_sdl_mixer => ["#{sdl_output_dir}/ios_arm/lib/#{sdl_mixer_lib_name}.a", "#{sdl_output_dir}/ios_i386/lib/#{sdl_mixer_lib_name}.a"] do
    FileUtils.mkdir_p "#{sdl_output_dir}/ios/lib"
    FileUtils.sh "lipo -create -output #{sdl_output_dir}/ios/lib/#{sdl_mixer_lib_name}.a #{sdl_output_dir}/ios_arm/lib/#{sdl_mixer_lib_name}.a #{sdl_output_dir}/ios_i386/lib/#{sdl_mixer_lib_name}.a"
  end

  task :ios_compile => [:ios_compile_sdl, :ios_compile_sdl_image, :ios_compile_sdl_mixer] do
  end
end