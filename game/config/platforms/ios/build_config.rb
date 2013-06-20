Game::Build.new('ios') do |conf|
  toolchain :ios
  
  conf.cc do |cc|
    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
  end

  # Linker settings
  conf.linker do |linker|
    linker.libraries = %w(SDL2_image SDL2_mixer SDL2 GLEW GL)

    linker.library_paths << "/Users/administrator/SDL/lib"
    linker.library_paths << "/System/Library/Frameworks/OpenGL.framework/Libraries"
    linker.library_paths << "/usr/lib"
  end
end

QGame::Build.new do |conf|
  toolchain :ios

  gem_include_paths = Dir.glob("build/mrbgems/**/include")

  conf.cc do |cc|
    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
    cc.include_paths.concat gem_include_paths
    cc.include_paths.concat ['/Users/administrator/SDL/include']
    cc.include_paths << "/usr/include/GL"
    # cc.include_paths << "/System/Library/Frameworks/OpenGL.framework/Headers"
    # cc.include_paths << "/Users/administrator/SDL/include"
  end

  # Linker settings
  conf.linker do |linker|
    linker.libraries = %w(libmruby)
    linker.library_paths = ["#{QGAME_ROOT}/build/host/lib"]
    linker.library_paths << "/usr/lib"
  end
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.gembox 'default'
end

MRuby::CrossBuild.new('ios') do |conf|
  toolchain :ios

    # Use standard Kernel#sprintf method
  conf.gem :core => "mruby-sprintf"

  # Use standard print/puts/p
  conf.gem :core => "mruby-print"

  # Use standard Math module
  conf.gem :core => "mruby-math"

  # Use standard Time class
  conf.gem :core => "mruby-time"

  # Use standard Struct class
  conf.gem :core => "mruby-struct"

  # Use extensional Enumerable module
  conf.gem :core => "mruby-enum-ext"

  # Use extensional String class
  conf.gem :core => "mruby-string-ext"

  # Use extensional Numeric class
  conf.gem :core => "mruby-numeric-ext"

  # Use extensional Array class
  conf.gem :core => "mruby-array-ext"

  # Use extensional Hash class
  conf.gem :core => "mruby-hash-ext"

  # Use extensional Range class
  conf.gem :core => "mruby-range-ext"

  # Use extensional Proc class
  conf.gem :core => "mruby-proc-ext"

  # Use extensional Symbol class
  conf.gem :core => "mruby-symbol-ext"

  # Use Random class
  conf.gem :core => "mruby-random"

  # Use ObjectSpace class
  conf.gem :core => "mruby-objectspace"

  # Use Fiber class
  conf.gem :core => "mruby-fiber"
end