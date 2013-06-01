Game.each_target do |target|
  current_dir = File.dirname(__FILE__).relative_path_from(Dir.pwd)
  relative_from_root = File.dirname(__FILE__).relative_path_from(PROJECT_ROOT)
  current_build_dir = "#{build_dir}/#{relative_from_root}"

  bin = "dev_application"

  p "finding source in: #{current_dir}/tools/#{bin}/*.c"
  p "build dir: #{build_dir}"
  p "current build dir: #{current_build_dir}"

  exec = exefile("#{build_dir}/bin/#{bin}")
  objs = Dir.glob("#{current_dir}/tools/#{bin}/*.c").map { |f| objfile(f.pathmap("#{current_build_dir}/tools/#{bin}/%n")) }
  p "Objs deps: #{objs}"
  libs = [libfile("#{build_dir}/lib/libmruby"), libfile("#{build_dir}/lib/libqgame")]
  p "Lib deps: #{libs}"

  file exec => objs + libs do |t|
    gem_flags = gems.map { |g| g.linker.flags }
    gem_flags_before_libraries = gems.map { |g| g.linker.flags_before_libraries }
    gem_flags_after_libraries = gems.map { |g| g.linker.flags_after_libraries }
    gem_libraries = gems.map { |g| g.linker.libraries }
    gem_library_paths = gems.map { |g| g.linker.library_paths }
    linker.run t.name, t.prerequisites, gem_libraries, gem_library_paths, gem_flags, gem_flags_before_libraries
  end

  if target == Game.targets['host']
    install_path = Game.targets['host'].exefile("#{PROJECT_ROOT}/bin/#{bin}")
    
    file install_path => exec do |t|
      p "Creating exec"
      FileUtils.rm_f t.name, { :verbose => $verbose }
      FileUtils.cp t.prerequisites.first, t.name, { :verbose => $verbose }
    end
  end
end