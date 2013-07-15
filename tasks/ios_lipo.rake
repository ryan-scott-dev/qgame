
namespace :freetype do
  output_dir = "#{DEPENDENCIES_DIR}/freetype"
  lib_name = 'libfreetype'

  task :compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end
end

namespace :sdl do
  output_dir = "#{DEPENDENCIES_DIR}/SDL2"
  lib_name = 'libSDL2'

  task :compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end
end

namespace :sdl do
  output_dir = "#{DEPENDENCIES_DIR}/SDL2"
  lib_name = 'libSDL2_image'

  task :compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end
end

namespace :sdl do
  output_dir = "#{DEPENDENCIES_DIR}/SDL2"
  lib_name = 'libSDL2_mixer'

  task :compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end
end

namespace :mruby do
  output_dir = "#{MRUBY_ROOT}/build"
  lib_name = 'libmruby'

  task :compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end
end

namespace :qgame do
  output_dir = "#{QGAME_ROOT}/build"
  lib_name = 'libqgame'

  task :compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end
end

namespace :game do
  output_dir = "#{PROJECT_ROOT}/build"
  lib_name = 'libgame'

  task :compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end
end