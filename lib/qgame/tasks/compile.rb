load 'qgame/tasks/mruby_compile.rake'

desc "build all targets, install (locally) in-repo"
task :compile do |args|
  puts "----------------------------------"
  puts "Compiling mruby..."
  puts "----------------------------------"
  Rake::Task['compile:mruby'].invoke(args)
  puts "----------------------------------"
  puts "Done!"
  puts ""
  puts ""
  puts "----------------------------------"
  puts "Compiling qgame..."
  puts "----------------------------------"
  # Rake::Task['compile:qgame'].invoke(args)
  puts "----------------------------------"
  puts "Done!"
  puts ""
  puts ""
  puts "----------------------------------"
  puts "Compiling your files..."
  puts "----------------------------------"
  # Rake::Task['compile:game'].invoke(args)
  puts "----------------------------------"
  puts "Done!"
  puts ""
  puts ""
end