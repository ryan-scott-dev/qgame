Game.each_target do
  current_dir = File.dirname(__FILE__).relative_path_from(Dir.pwd)
  relative_from_root = File.dirname(__FILE__).relative_path_from(QGAME_ROOT)
  current_build_dir = "#{build_dir}/#{relative_from_root}"

  exec = exefile("#{current_build_dir}/main")
  p "Generating Exectuable: #{exec}"
  clib = "#{current_build_dir}/main.c"
  mlib = clib.ext(exts.object)
  init = "#{current_dir}/init_application.c"
  application = "#{PROJECT_ROOT}/game/lib/application.rb"

  application_lib = libfile("#{current_build_dir}/mrbtest")
  file application_lib => [mlib].flatten do |t|
    archiver.run t.name, t.prerequisites
  end

  driver_obj = objfile("#{current_build_dir}/driver")
  dependencies = [driver_obj, application_lib]
  dependencies << libfile("#{QGame::Build.current.build_dir}/lib/libmruby")
  dependencies << libfile("#{QGame::Build.current.build_dir}/lib/libqgame")

  p "dependencies: #{dependencies}"

  file exec => dependencies do |t|
    gem_flags = gems.map { |g| g.linker.flags }
    gem_flags_before_libraries = gems.map { |g| g.linker.flags_before_libraries }
    gem_flags_after_libraries = gems.map { |g| g.linker.flags_after_libraries }
    gem_libraries = gems.map { |g| g.linker.libraries }
    gem_library_paths = gems.map { |g| g.linker.library_paths }
    linker.run t.name, t.prerequisites, gem_libraries, gem_library_paths, gem_flags, gem_flags_before_libraries
  end

  file mlib => [clib]
  file clib => [mrbcfile, init, application] do |t|
    _pp "GEN", "*.rb", "#{clib.relative_path}"
    FileUtils.mkdir_p File.dirname(clib)
    open(clib, 'w') do |f|
      f.puts IO.read(init)
      mrbc.run f, application, 'mrbapp_irep'
    end
  end
end