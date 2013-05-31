$PROJ_NAME::Build.new do |conf|
  toolchain :clang
  
  # C compiler settings
  conf.cc do |cc|
    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
  end

  # Linker settings
  conf.linker do |linker|
    linker.libraries = %w(libmruby, libqgame)
    linker.library_paths = ["#{QGAME_ROOT}/build/host/lib"]
  end

  # load specific platform settings
end

QGame::Build.new do |conf|
  toolchain :clang

  # C compiler settings
  conf.cc do |cc|
    cc.include_paths = ["#{QGAME_ROOT}/include", "#{MRUBY_ROOT}/include"]
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