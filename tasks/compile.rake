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

MRUBY_ROOT = ENV['MRUBY_ROOT'] || "#{PROJECT_ROOT}/build/mruby"
PLATFORM = ENV['PLATFORM'] || default_platform
MRUBY_BUILD_HOST_IS_CYGWIN = RUBY_PLATFORM.include?('cygwin')

# load build systems
load "#{MRUBY_ROOT}/tasks/ruby_ext.rake"
load "#{MRUBY_ROOT}/tasks/mruby_build.rake"
load "#{MRUBY_ROOT}/tasks/mrbgem_spec.rake"
load "#{QGAME_ROOT}/tasks/qgame_build.rake"
load "#{QGAME_ROOT}/tasks/game_build.rake"

# load configuration file
load "#{PROJECT_ROOT}/config/build_config.rb"
MRUBY_CONFIG = (ENV['BUILD_CONFIG'] && ENV['BUILD_CONFIG'] != '') ? ENV['BUILD_CONFIG'] : "#{PROJECT_ROOT}/config/platforms/#{PLATFORM.to_s}/build_config.rb"
load MRUBY_CONFIG

# load basic rules
puts ""
puts "----------------------------------"
p "Define MRuby build rules"
puts "----------------------------------"
MRuby.each_target do |build|
  build.define_rules
end

# load basic rules
puts ""
puts "----------------------------------"
p "Define QGame build rules"
puts "----------------------------------"
QGame.each_target do |build|
  build.define_rules
end

# load basic rules
puts ""
puts "----------------------------------"
p "Define Game build rules"
puts "----------------------------------"
Game.each_target do |build|
  build.define_rules
end

puts ""
puts "----------------------------------"
puts "Loading Compile rules"
puts "----------------------------------"

load "#{QGAME_ROOT}/tasks/mruby_compile.rake"
load "#{QGAME_ROOT}/tasks/qgame_compile.rake"
load "#{QGAME_ROOT}/tasks/game_compile.rake"
puts "----------------------------------"
puts "----------------------------------"
puts ""
desc "build all targets, install (locally) in-repo"
task :compile do |args|
  puts "----------------------------------"
  puts "Compiling mruby..."
  puts "----------------------------------"
  Rake::Task['mruby:compile'].invoke(args)
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
  Rake::Task['game:compile'].invoke(args)
  # This should produce a runnable application
  puts "----------------------------------"
  puts "Done!"
  puts ""
  puts ""
end

task :clean do
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