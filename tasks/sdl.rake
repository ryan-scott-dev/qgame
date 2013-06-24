require 'fileutils'

current_dir = Dir.pwd

namespace :sdl do
  def download_file(url, path)
    FileUtils.sh "curl -o #{path} #{url}"
  end

  DEPENDENCIES_DIR = "#{QGAME_ROOT}/dependencies"
  SDL_URL = 'http://www.libsdl.org/tmp/release/SDL2-2.0.0.tar.gz'
  CLONE_DIR = "#{DEPENDENCIES_DIR}/SDL2-2.0.0.tar.gz"
  EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/SDL2-2.0.0"
  
  QGame.each_target do |target|
    OUTPUT_DIR = "#{DEPENDENCIES_DIR}/SDL2/#{target.name}"

    file CLONE_DIR do |t|
      download_file(SDL_URL, CLONE_DIR)  
    end

    directory EXTRACTED_DIR => CLONE_DIR do |t|
      FileUtils.sh "tar -C #{DEPENDENCIES_DIR} -zxf #{CLONE_DIR}"
    end

    directory OUTPUT_DIR => EXTRACTED_DIR do |t|
      FileUtils.cd EXTRACTED_DIR
      FileUtils.sh "./configure --prefix #{OUTPUT_DIR}"
      FileUtils.sh 'make'
      FileUtils.sh 'make install'
      FileUtils.cd current_dir
    end

    task :compile => OUTPUT_DIR do
    end
  end
end