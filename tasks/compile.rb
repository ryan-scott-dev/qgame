def default_platform
  case 
  when RUBY_PLATFORM.downcase.include?("darwin")
    return :osx
  when RUBY_PLATFORM.downcase.include?("linux")
    return :linux
  when RUBY_PLATFORM.downcase.include?("mswin")
    return :win
  end
end

PROJECT_ROOT = Dir.pwd
MRUBY_ROOT = ENV['MRUBY_ROOT'] || "#{PROJECT_ROOT}/build/mruby"
PLATFORM = ENV['PLATFORM'] || default_platform
MRUBY_BUILD_HOST_IS_CYGWIN = RUBY_PLATFORM.include?('cygwin')

# load build systems
load "#{MRUBY_ROOT}/tasks/ruby_ext.rake"
load "#{MRUBY_ROOT}/tasks/mruby_build.rake"
load "#{MRUBY_ROOT}/tasks/mrbgem_spec.rake"
load "#{QGAME_ROOT}/tasks/qgame_build.rake"

# load configuration file
# load "#{PROJECT_ROOT}/config/build_config.rb"
MRUBY_CONFIG = (ENV['BUILD_CONFIG'] && ENV['BUILD_CONFIG'] != '') ? ENV['BUILD_CONFIG'] : "#{PROJECT_ROOT}/config/platforms/#{PLATFORM.to_s}/build_config.rb"
load MRUBY_CONFIG

# load basic rules
MRuby.each_target do |build|
  build.define_rules
  p "Mruby build"
end

# load basic rules
QGame.each_target do |build|
  build.define_rules

  p "QGame build"
end

load "#{QGAME_ROOT}/tasks/mruby_compile.rake"
load "#{QGAME_ROOT}/tasks/qgame_compile.rake"

desc "build all targets, install (locally) in-repo"
task :compile do |args|
  puts "----------------------------------"
  puts "Compiling mruby..."
  puts "----------------------------------"
  Rake::Task['compile:mruby'].invoke(args)
  # This should produce a linkable mruby library
  puts "----------------------------------"
  puts "Done!"
  puts ""
  puts ""
  puts "----------------------------------"
  puts "Compiling qgame..."
  puts "----------------------------------"
  Rake::Task['qgame:compile'].invoke(args)
  # This should produce a linkable qgame library
  puts "----------------------------------"
  puts "Done!"
  puts ""
  puts ""
  puts "----------------------------------"
  puts "Compiling your files..."
  puts "----------------------------------"
  # Rake::Task['compile:game'].invoke(args)
  # This should produce a runnable application
  puts "----------------------------------"
  puts "Done!"
  puts ""
  puts ""
end