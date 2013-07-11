require 'fileutils'

current_dir = Dir.pwd

namespace :freetype do
  def download_file(url, path)
    FileUtils.sh "curl -L -o #{path} #{url}"
  end

  DEPENDENCIES_DIR = "#{QGAME_ROOT}/dependencies"
  FREETYPE_URL = 'http://download.savannah.gnu.org/releases/freetype/freetype-2.5.0.1.tar.bz2'
  FREETYPE_CLONE_DIR = "#{DEPENDENCIES_DIR}/freetype-2.5.0.1.tar.bz2"
  FREETYPE_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/freetype-2.5.0.1"

  FREETYPE_HOST_OUTPUT = "#{DEPENDENCIES_DIR}/freetype/host/lib/libfreetype.a"

  libs = []

  QGame.each_target do |target|
    output_dir = "#{DEPENDENCIES_DIR}/freetype/#{target.name}"

    freetype_output_file = target.libfile("#{output_dir}/lib/libfreetype")
    libs << freetype_output_file
    
    file FREETYPE_CLONE_DIR do |t|
      download_file(FREETYPE_URL, FREETYPE_CLONE_DIR)  
    end

    directory FREETYPE_EXTRACTED_DIR => FREETYPE_CLONE_DIR do |t|
      FileUtils.sh "tar -C #{DEPENDENCIES_DIR} -zxf #{FREETYPE_CLONE_DIR}"
    end

    file freetype_output_file => FREETYPE_EXTRACTED_DIR do |t|
      target.build_freetype(directory: FREETYPE_EXTRACTED_DIR, 
        current_dir: current_dir, output_dir: output_dir, library: target.libfile("libfreetype"), output_file: freetype_output_file)
    end
  end

  task :compile => libs do
  end
end