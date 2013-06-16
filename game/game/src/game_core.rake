Game.each_target do
  current_dir = File.dirname(__FILE__).relative_path_from(Dir.pwd)
  relative_from_root = File.dirname(__FILE__).relative_path_from(PROJECT_ROOT)
  current_build_dir = "#{build_dir}/#{relative_from_root}"
  
  objs = Dir.glob("#{current_dir}/**/*.c").map { |f| objfile(f.pathmap("#{current_build_dir}/%d/%n")) }
  self.libgame << objs

  file libfile("#{build_dir}/lib/libgame_core") => objs do |t|
    archiver.run t.name, t.prerequisites
  end
end
