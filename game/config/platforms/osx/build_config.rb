Game::Build.new do |conf|
  toolchain :clang
  conf.mrbc do |mrbc|
    mrbc.compile_options += ' -g'
  end

  # C compiler settings
  conf.cc do |cc|
    cc.defines = %w(ENABLE_DEBUG, MRB_USE_FLOAT)

    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
    cc.include_paths << "#{QGAME_ROOT}/build/#{conf.name}/freetype/include"
    cc.include_paths << "#{QGAME_ROOT}/build/#{conf.name}/freetype/include/freetype2"
    cc.include_paths << "#{QGAME_ROOT}/build/#{conf.name}/sdl/include"
  end

  # Linker settings
  conf.linker do |linker|
    linker.libraries = %w(SDL2_image SDL2_mixer SDL2 GL GLU freetype)

    linker.library_paths << "#{QGAME_ROOT}/build/#{conf.name}/sdl/lib"
    linker.library_paths << "/System/Library/Frameworks/OpenGL.framework/Libraries"
    linker.library_paths << "#{QGAME_ROOT}/build/#{conf.name}/freetype/lib"
  end

  # load specific platform settings
end

QGame::Build.new do |conf|
  toolchain :clang

  gem_include_paths = Dir.glob("build/mrbgems/**/include")

  conf.mrbc do |mrbc|
    mrbc.compile_options += ' -g'
  end

  # C compiler settings
  conf.cc do |cc|
    cc.defines = %w(ENABLE_DEBUG, MRB_USE_FLOAT)

    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
    cc.include_paths.concat gem_include_paths
    cc.include_paths << "#{QGAME_ROOT}/build/#{conf.name}/freetype/include"
    cc.include_paths << "#{QGAME_ROOT}/build/#{conf.name}/freetype/include/freetype2"
    cc.include_paths << "#{QGAME_ROOT}/build/#{conf.name}/sdl/include"
  end

  # Linker settings
  conf.linker do |linker|
    linker.libraries = %w(libmruby)
    linker.library_paths = ["#{QGAME_ROOT}/build/#{conf.name}/lib"]
    linker.library_paths << "#{QGAME_ROOT}/build/#{conf.name}/freetype/lib"
    linker.library_paths << "#{QGAME_ROOT}/build/#{conf.name}/sdl/lib"
  end
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.gembox 'default'
  conf.gem :core => "mruby-eval"

  conf.mrbc do |mrbc|
    mrbc.compile_options += ' -g'
  end

  conf.cc do |cc|
    cc.defines = %w(ENABLE_DEBUG, MRB_USE_FLOAT)
  end
  # load specific platform settings
end