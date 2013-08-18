require 'fileutils'

current_dir = Dir.pwd

namespace :freetype do
  FREETYPE_EXTRACTED_DIR = "#{DEPENDENCIES_DIR}/freetype"

  FREETYPE_HOST_OUTPUT = "#{DEPENDENCIES_DIR}/freetype/host/lib/libfreetype.a"

  libs = []

  QGame.each_target do |target|
    output_dir = "#{target.build_dir}/freetype/"

    freetype_output_file = target.libfile("#{output_dir}/lib/libfreetype")
    libs << freetype_output_file

    file freetype_output_file => FREETYPE_EXTRACTED_DIR do |t|
      target.build_freetype(directory: FREETYPE_EXTRACTED_DIR, 
        current_dir: current_dir, output_dir: output_dir, library: target.libfile("libfreetype"), 
        output_file: freetype_output_file, target: target)
    end
  end

  task :compile => libs do
  end

  if COMPILE_PLATFORM.is_ios?
    def ios_arm_output_dir
      "#{QGame.targets['ios_arm'].build_dir}/freetype/"
    end

    def ios_device_output_dir
      "#{QGame.targets['ios_i386'].build_dir}/freetype/"
    end

    def ios_output_dir
      "#{QGame.targets['ios'].build_dir}/freetype/"
    end

    base_output_dir = "#{QGAME_ROOT}/build/freetype/"
    lib_name = 'libfreetype'

    task :ios_compile => ["#{ios_arm_output_dir}/lib/#{lib_name}.a", "#{ios_device_output_dir}/lib/#{lib_name}.a"] do
      FileUtils.mkdir_p "#{ios_output_dir}/lib"
      FileUtils.cp_r "#{ios_arm_output_dir}/include", "#{ios_output_dir}"
      FileUtils.sh "lipo -create -output #{ios_output_dir}/lib/#{lib_name}.a #{ios_arm_output_dir}/lib/#{lib_name}.a #{ios_device_output_dir}/lib/#{lib_name}.a"
    end
  end
end