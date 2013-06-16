Game.each_target do
  current_dir = File.dirname(__FILE__).relative_path_from(Dir.pwd)
  relative_from_root = File.dirname(__FILE__).relative_path_from(PROJECT_ROOT)
  current_build_dir = "#{build_dir}/#{relative_from_root}"
  
  self.libgame << objfile("#{current_build_dir}/gamelib")
  
  file objfile("#{current_build_dir}/gamelib") => "#{current_build_dir}/gamelib.c"
  ruby_files = Dir.glob("#{current_dir}/**/*.rb")
  ruby_files.reject! {|file| file.include? 'application.rb'}
  
  file "#{current_build_dir}/gamelib.c" => [mrbcfile] + ruby_files.sort do |t|
    mrbc_, *rbfiles = t.prerequisites
    FileUtils.mkdir_p File.dirname(t.name)
    open(t.name, 'w') do |f|
      _pp "GEN", "*.rb", "#{t.name.relative_path}"
      f.puts File.read("#{current_dir}/init_gamelib.c")
      mrbc.run f, rbfiles, 'mrbgamelib_irep'
    end
  end
end
