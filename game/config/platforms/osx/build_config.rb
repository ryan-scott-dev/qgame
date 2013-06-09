Game::Build.new do |conf|
  toolchain :clang
 
  # C compiler settings
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

  # load specific platform settings
end

QGame::Build.new do |conf|
  toolchain :clang

  gem_include_paths = Dir.glob("build/mrbgems/**/include")

  # C compiler settings
  conf.cc do |cc|
    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
    cc.include_paths.concat gem_include_paths
    cc.include_paths.concat ['/Users/administrator/SDL/include']
    cc.include_paths << "/usr/include/GL"
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

  # load specific platform settings
end