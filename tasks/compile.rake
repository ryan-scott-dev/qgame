
def header(header_name)
  if $verbose
    puts ""
    puts "----------------------------------"
    puts header_name
    puts "----------------------------------"
  end
end

def footer
  if $verbose
    puts "----------------------------------"
    puts "Done!"
    puts ""
  end
end

task :prepare_compile do |args|
  load "#{QGAME_ROOT}/tasks/platforms.rake"

  MRUBY_ROOT = ENV['MRUBY_ROOT'] || "#{QGAME_ROOT}/dependencies/mruby"
  COMPILE_PLATFORM = Platform.platform_for(ENV['PLATFORM']) || Platform.host_platform
  MRUBY_BUILD_HOST_IS_CYGWIN = Platform.host_platform.is_cygwin?
  DEPENDENCIES_DIR = "#{QGAME_ROOT}/dependencies"

  # load build systems
  load "#{MRUBY_ROOT}/tasks/ruby_ext.rake"
  load "#{MRUBY_ROOT}/tasks/mruby_build.rake"
  load "#{QGAME_ROOT}/tasks/mruby_build.rake"
  load "#{MRUBY_ROOT}/tasks/mrbgem_spec.rake"
  load "#{QGAME_ROOT}/tasks/base_build.rake"
  load "#{QGAME_ROOT}/tasks/qgame_build.rake"
  load "#{QGAME_ROOT}/tasks/game_build.rake"
  load "#{QGAME_ROOT}/tasks/ios_build.rake"

  # load configuration file
  MRUBY_CONFIG = (ENV['BUILD_CONFIG'] && ENV['BUILD_CONFIG'] != '') ? ENV['BUILD_CONFIG'] : "#{PROJECT_ROOT}/config/platforms/#{COMPILE_PLATFORM.name}/build_config.rb"
  load MRUBY_CONFIG

  load "#{QGAME_ROOT}/tasks/sdl.rake"
  load "#{QGAME_ROOT}/tasks/freetype.rake"

  load "#{QGAME_ROOT}/tasks/ios-sim.rake" if COMPILE_PLATFORM.is_ios?

  # load basic rules
  header "Define MRuby build rules"
  MRuby.each_target do |build|
    build.define_rules
  end

  # load basic rules
  header "Define QGame build rules"
  QGame.each_target do |build|
    build.define_rules
  end

  # load basic rules
  header "Define Game build rules"
  Game.each_target do |build|
    build.define_rules
  end

  header "Loading Compile rules"
  
  load "#{QGAME_ROOT}/tasks/mruby_compile.rake"
  load "#{QGAME_ROOT}/tasks/qgame_compile.rake"
  load "#{QGAME_ROOT}/tasks/game_compile.rake"
  load "#{QGAME_ROOT}/tasks/app_compile.rake"
end

desc "build all targets, install (locally) in-repo"
task :compile => :prepare_compile do |args|
  header "Compiling sdl..."
  Rake::Task['sdl:compile'].invoke(args)
  Rake::Task['sdl:ios_compile'].invoke(args) if COMPILE_PLATFORM.is_ios?
  # This should produce a linkable mruby library
  footer

  header "Compiling freetype..."
  Rake::Task['freetype:compile'].invoke(args)
  Rake::Task['freetype:ios_compile'].invoke(args) if COMPILE_PLATFORM.is_ios?
  # This should produce a linkable mruby library
  footer

  header "Compiling mruby..."
  Rake::Task['mruby:compile'].invoke(args)
  Rake::Task['mruby:ios_compile'].invoke(args) if COMPILE_PLATFORM.is_ios?
  # This should produce a linkable mruby library
  footer

  header "Compiling qgame..."
  Rake::Task['qgame:compile'].invoke(args)
  Rake::Task['qgame:ios_compile'].invoke(args) if COMPILE_PLATFORM.is_ios?
  # This should produce a linkable qgame library
  footer
  
  header "Compiling your files..."
  Rake::Task['game:compile'].invoke(args)
  Rake::Task['game:ios_compile'].invoke(args) if COMPILE_PLATFORM.is_ios?
  footer

  header "Building the application..."
  Rake::Task['game:app_compile'].invoke(args)
  
  # This should produce a runnable application
  footer
end

task :clean => :prepare_compile do
  MRuby.each_target do |t|
    FileUtils.rm_rf t.build_dir, { :verbose => $verbose }
  end
  QGame.each_target do |t|
    FileUtils.rm_rf t.build_dir, { :verbose => $verbose }
  end

  Rake::Task['mruby:clean'].invoke
  Rake::Task['qgame:clean'].invoke
  Rake::Task['game:clean'].invoke

  puts "Cleaned up build folders"
end