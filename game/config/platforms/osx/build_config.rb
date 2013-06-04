Game::Build.new do |conf|
  toolchain :clang
 
  # C compiler settings
  conf.cc do |cc|
    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
  end

  # Linker settings
  conf.linker do |linker|
    linker.libraries = %w(SDL2)
    linker.library_paths = ["/Users/administrator/SDL/lib"]
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
    cc.include_paths.concat ['/Library/Frameworks/SDL.framework/Headers']
  end

  # Linker settings
  conf.linker do |linker|
    linker.libraries = %w(libmruby)
    linker.library_paths = ["#{QGAME_ROOT}/build/host/lib"]
  end
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.gembox 'default'

  # load specific platform settings
end