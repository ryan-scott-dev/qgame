namespace :mruby do
  # load custom rules
  load "#{MRUBY_ROOT}/src/mruby_core.rake"
  load "#{MRUBY_ROOT}/mrblib/mrblib.rake"
  load "#{MRUBY_ROOT}/tools/mrbc/mrbc.rake"

  load "#{MRUBY_ROOT}/tasks/mrbgems.rake"
  load "#{MRUBY_ROOT}/tasks/libmruby.rake"

  load "#{MRUBY_ROOT}/tasks/mrbgems_test.rake"
  load "#{MRUBY_ROOT}/test/mrbtest.rake"

  mruby_depfiles = MRuby.targets['host'].bins.map do |bin|
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
          mruby_depfiles += [ install_path ]
        else
          mruby_depfiles += [ exec ]
        end
      end
    end
  end

  mruby_depfiles += MRuby.targets.map { |n, t|
    [t.libfile("#{t.build_dir}/lib/libmruby")]
  }.flatten

  mruby_depfiles += MRuby.targets.reject { |n, t| n == 'host' }.map { |n, t|
    t.bins.map { |bin| t.exefile("#{t.build_dir}/bin/#{bin}") }
  }.flatten

  desc "build all targets, install (locally) in-repo"
  task :compile => mruby_depfiles do |args|
    
  end

  output_dir = "#{MRUBY_ROOT}/build"
  lib_name = 'libmruby'

  task :ios_compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.mkdir_p "#{output_dir}/ios/lib"
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end

  task :clean do
    MRuby.each_target do |t|
      FileUtils.rm_rf t.build_dir, { :verbose => $verbose }
    end
    FileUtils.rm_rf "#{output_dir}/ios/"
    FileUtils.rm_f mruby_depfiles, { :verbose => $verbose }
  end
end