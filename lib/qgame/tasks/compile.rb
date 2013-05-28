load 'qgame/tasks/mruby_compile.rake'
load 'qgame/tasks/qgame_compile.rake'

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
  Rake::Task['compile:qgame'].invoke(args)
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