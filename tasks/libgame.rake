Game.each_target do
  file libfile("#{build_dir}/lib/libgame") => libgame.flatten do |t|
    archiver.run t.name, t.prerequisites
    open("#{build_dir}/lib/libgame.flags.mak", 'w') do |f|
      f.puts 'GAME_CFLAGS = %s' % cc.all_flags.gsub('"', '\\"') 

      gem_flags = gems.map { |g| g.linker.flags }
      gem_library_paths = gems.map { |g| g.linker.library_paths }
      f.puts 'GAME_LDFLAGS = %s' % linker.all_flags(gem_library_paths, gem_flags).gsub('"', '\\"') 

      gem_flags_before_libraries = gems.map { |g| g.linker.flags_before_libraries }
      f.puts 'GAME_LDFLAGS_BEFORE_LIBS = %s' % [linker.flags_before_libraries, gem_flags_before_libraries].flatten.join(' ').gsub('"', '\\"') 

      gem_libraries = gems.map { |g| g.linker.libraries }
      f.puts 'GAME_LIBS = %s' % linker.library_flags(gem_libraries).gsub('"', '\\"') 
    end
  end
end