namespace :qgame do
  depfiles = QGame.targets.map { |n, t|
    [t.libfile("#{t.build_dir}/lib/libqgame")]
  }.flatten

  task :dependencies => depfiles do
  end

  # load custom rules
  task :qgame_prepare do
    load "#{QGAME_ROOT}/src/qgame_core.rake"
    load "#{QGAME_ROOT}/lib/qgame/qgamelib.rake"
    load "#{QGAME_ROOT}/tasks/qgame_gems.rake"
    load "#{QGAME_ROOT}/tasks/libqgame.rake"

    Rake::Task["qgame:dependencies"].invoke
  end

  desc "build all targets, install (locally) in-repo"
  task :compile => :qgame_prepare do |args|
  end

  output_dir = "#{QGAME_ROOT}/build"
  lib_name = 'libqgame'

  task :ios_compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.mkdir_p "#{output_dir}/ios/lib"
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end

  task :clean do
    QGame.each_target do |t|
      FileUtils.rm_rf t.build_dir, { :verbose => $verbose }
    end
    FileUtils.rm_rf "#{output_dir}/ios/"
    FileUtils.rm_f depfiles, { :verbose => $verbose }
  end
end