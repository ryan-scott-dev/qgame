Game::Build.new do |conf|
  toolchain :clang
 
  # C compiler settings
  conf.cc do |cc|
    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
    cc.include_paths << "#{QGAME_ROOT}/dependencies/freetype/#{conf.name}/include"
    cc.include_paths << "#{QGAME_ROOT}/dependencies/SDL2/#{conf.name}/include"
  end

  # Linker settings
  conf.linker do |linker|
    linker.libraries = %w(SDL2_image SDL2_mixer SDL2 GLEW GL freetype)

    linker.library_paths << "#{QGAME_ROOT}/dependencies/SDL2/#{conf.name}/lib"
    linker.library_paths << "/System/Library/Frameworks/OpenGL.framework/Libraries"
    linker.library_paths << "#{QGAME_ROOT}/dependencies/freetype/#{conf.name}/lib"
  end

  # load specific platform settings
end

QGame::Build.new do |conf|
  toolchain :clang

  gem_include_paths = Dir.glob("build/mrbgems/**/include")

  # C compiler settings
  conf.cc do |cc|
    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
    cc.include_paths.concat gem_include_paths
    cc.include_paths << "#{QGAME_ROOT}/dependencies/SDL2/#{conf.name}/include"
    cc.include_paths << "#{QGAME_ROOT}/dependencies/freetype/#{conf.name}/include"
  end

  # Linker settings
  conf.linker do |linker|
    linker.libraries = %w(libmruby)
    linker.library_paths = ["#{QGAME_ROOT}/build/host/lib"]
    linker.library_paths << "#{QGAME_ROOT}/dependencies/freetype/#{conf.name}/lib"
    linker.library_paths << "#{QGAME_ROOT}/dependencies/SDL2/#{conf.name}/lib"
  end
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.gembox 'default'

  # load specific platform settings
end