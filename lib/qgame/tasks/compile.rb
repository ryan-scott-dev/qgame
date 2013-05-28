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

# load configuration file
load "#{PROJECT_ROOT}/config/build_config.rb"
MRUBY_CONFIG = (ENV['BUILD_CONFIG'] && ENV['BUILD_CONFIG'] != '') ? ENV['BUILD_CONFIG'] : "#{PROJECT_ROOT}/config/platforms/#{PLATFORM.to_s}/build_config.rb"
load MRUBY_CONFIG

# load basic rules
MRuby.each_target do |build|
  build.define_rules
end

# load custom rules
load "#{MRUBY_ROOT}/src/mruby_core.rake"
load "#{MRUBY_ROOT}/mrblib/mrblib.rake"
load "#{MRUBY_ROOT}/tools/mrbc/mrbc.rake"

load "#{MRUBY_ROOT}/tasks/mrbgems.rake"
load "#{MRUBY_ROOT}/tasks/libmruby.rake"

load "#{MRUBY_ROOT}/tasks/mrbgems_test.rake"
load "#{MRUBY_ROOT}/test/mrbtest.rake"

depfiles = MRuby.targets['host'].bins.map do |bin|
  install_path = MRuby.targets['host'].exefile("#{MRUBY_ROOT}/bin/#{bin}")
  source_path = MRuby.targets['host'].exefile("#{MRuby.targets['host'].build_dir}/bin/#{bin}")
  
  file install_path => source_path do |t|
    FileUtils.rm_f t.name, { :verbose => $verbose }
    FileUtils.cp t.prerequisites.first, t.name, { :verbose => $verbose }
  end
  
  install_path
end

MRuby.each_target do |target|
  gems.map do |gem|
    current_dir = gem.dir.relative_path_from(Dir.pwd)
    relative_from_root = gem.dir.relative_path_from(MRUBY_ROOT)
    current_build_dir = "#{build_dir}/#{relative_from_root}"

    gem.bins.each do |bin|
      exec = exefile("#{build_dir}/bin/#{bin}")
      objs = Dir.glob("#{current_dir}/tools/#{bin}/*.c").map { |f| objfile(f.pathmap("#{current_build_dir}/tools/#{bin}/%n")) }

      file exec => objs + [libfile("#{build_dir}/lib/libmruby")] do |t|
        gem_flags = gems.map { |g| g.linker.flags }
        gem_flags_before_libraries = gems.map { |g| g.linker.flags_before_libraries }
        gem_flags_after_libraries = gems.map { |g| g.linker.flags_after_libraries }
        gem_libraries = gems.map { |g| g.linker.libraries }
        gem_library_paths = gems.map { |g| g.linker.library_paths }
        linker.run t.name, t.prerequisites, gem_libraries, gem_library_paths, gem_flags, gem_flags_before_libraries
      end

      if target == MRuby.targets['host']
        install_path = MRuby.targets['host'].exefile("#{MRUBY_ROOT}/bin/#{bin}")

        file install_path => exec do |t|
          FileUtils.rm_f t.name, { :verbose => $verbose }
          FileUtils.cp t.prerequisites.first, t.name, { :verbose => $verbose }
        end
        depfiles += [ install_path ]
      else
        depfiles += [ exec ]
      end
    end
  end
end

depfiles += MRuby.targets.map { |n, t|
  [t.libfile("#{t.build_dir}/lib/libmruby")]
}.flatten

depfiles += MRuby.targets.reject { |n, t| n == 'host' }.map { |n, t|
  t.bins.map { |bin| t.exefile("#{t.build_dir}/bin/#{bin}") }
}.flatten

desc "build all targets, install (locally) in-repo"
task :compile => depfiles do |args|
  puts
  puts "Build summary:"
  puts
  MRuby.each_target do
    print_build_summary
  end
end