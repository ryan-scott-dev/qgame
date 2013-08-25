require 'fileutils'

current_dir = Dir.pwd

namespace :sdl do
  def download_file(url, path)
    FileUtils.sh "curl -o #{path} #{url}"
  end

  SDL_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL"
  SDL_IMAGE_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL_image"
  SDL_MIXER_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL_mixer"

  libs = []
  ios_libs = []

  QGame.each_target do |target|
    output_dir = "#{target.build_dir}/sdl"

    sdl_output_file = target.libfile("#{output_dir}/lib/libSDL2")
    sdl_image_output_file = target.libfile("#{output_dir}/lib/libSDL2_image")
    sdl_mixer_output_file = target.libfile("#{output_dir}/lib/libSDL2_mixer")
    libs << sdl_output_file
    libs << sdl_image_output_file
    libs << sdl_mixer_output_file

    file sdl_output_file => SDL_EXTRACTED_DIR do |t|
      target.build_sdl(directory: SDL_EXTRACTED_DIR,
        current_dir: current_dir, output_dir: output_dir, library: target.libfile("libSDL2"),
        output_file: sdl_output_file, target: target)
    end

    file sdl_image_output_file => [sdl_output_file, SDL_IMAGE_EXTRACTED_DIR] do |t|
      target.build_sdl_library(directory: SDL_IMAGE_EXTRACTED_DIR,
        current_dir: current_dir, output_dir: output_dir, library: target.libfile("libSDL2_image"),
        output_file: sdl_image_output_file, target: target, library_name: 'SDL_image')
    end

    file sdl_mixer_output_file => [sdl_output_file, SDL_MIXER_EXTRACTED_DIR] do |t|
      target.build_sdl_library(directory: SDL_MIXER_EXTRACTED_DIR,
        current_dir: current_dir, output_dir: output_dir, library: target.libfile("libSDL2_mixer"),
        output_file: sdl_mixer_output_file, target: target, library_name: 'SDL_mixer')
    end
  end

  task :compile => libs do
  end

  sdl_output_dir = "#{QGAME_ROOT}/build"
  sdl_lib_name = 'libSDL2'

  task :ios_compile_sdl => ["#{sdl_output_dir}/ios_arm/sdl/lib/#{sdl_lib_name}.a", "#{sdl_output_dir}/ios_i386/sdl/lib/#{sdl_lib_name}.a"] do
    FileUtils.mkdir_p "#{sdl_output_dir}/ios/sdl/lib"
    FileUtils.cp_r "#{sdl_output_dir}/ios_arm/sdl/include", "#{sdl_output_dir}/ios/sdl"

    FileUtils.sh "lipo -create -output #{sdl_output_dir}/ios/sdl/lib/#{sdl_lib_name}.a #{sdl_output_dir}/ios_arm/sdl/lib/#{sdl_lib_name}.a #{sdl_output_dir}/ios_i386/sdl/lib/#{sdl_lib_name}.a"
  end

  sdl_image_lib_name = 'libSDL2_image'

  task :ios_compile_sdl_image => ["#{sdl_output_dir}/ios_arm/sdl/lib/#{sdl_image_lib_name}.a", "#{sdl_output_dir}/ios_i386/sdl/lib/#{sdl_image_lib_name}.a"] do
    FileUtils.mkdir_p "#{sdl_output_dir}/ios/sdl/lib"
    FileUtils.sh "lipo -create -output #{sdl_output_dir}/ios/sdl/lib/#{sdl_image_lib_name}.a #{sdl_output_dir}/ios_arm/sdl/lib/#{sdl_image_lib_name}.a #{sdl_output_dir}/ios_i386/sdl/lib/#{sdl_image_lib_name}.a"
  end

  sdl_mixer_lib_name = 'libSDL2_mixer'

  task :ios_compile_sdl_mixer => ["#{sdl_output_dir}/ios_arm/sdl/lib/#{sdl_mixer_lib_name}.a", "#{sdl_output_dir}/ios_i386/sdl/lib/#{sdl_mixer_lib_name}.a"] do
    FileUtils.mkdir_p "#{sdl_output_dir}/ios/sdl/lib"
    FileUtils.sh "lipo -create -output #{sdl_output_dir}/ios/sdl/lib/#{sdl_mixer_lib_name}.a #{sdl_output_dir}/ios_arm/sdl/lib/#{sdl_mixer_lib_name}.a #{sdl_output_dir}/ios_i386/sdl/lib/#{sdl_mixer_lib_name}.a"
  end

  task :ios_compile => [:ios_compile_sdl, :ios_compile_sdl_image, :ios_compile_sdl_mixer] do
  end
end