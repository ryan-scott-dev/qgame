QGame.each_target do
  current_dir = File.dirname(__FILE__)
  relative_from_root = File.dirname(__FILE__).relative_path_from(QGAME_ROOT)

  current_build_dir = "#{build_dir}/#{relative_from_root}"
  
  self.libqgame << objfile("#{current_build_dir}/qgamelib")
  
  file objfile("#{current_build_dir}/qgamelib") => "#{current_build_dir}/qgamelib.c"
  file "#{current_build_dir}/qgamelib.c" => [mrbcfile] + Dir.glob("#{current_dir}/*.rb") + Dir.glob("#{current_dir}/*/*.rb") do |t|
    mrbc_, *rbfiles = t.prerequisites
    FileUtils.mkdir_p File.dirname(t.name)
    open(t.name, 'w') do |f|
      _pp "GEN", "*.rb", "#{t.name.relative_path}"
      f.puts File.read("#{current_dir}/init_qgamelib.c")
      mrbc.run f, rbfiles, 'mrbqgamelib_irep'
    end
  end
end
