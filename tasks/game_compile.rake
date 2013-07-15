namespace :game do
  depfiles = Game.targets.map { |n, t|
    deps = []
    deps << t.exefile("#{t.build_dir}/tools/main") if t.bins.find{ |s| s.to_s == 'main' }
    deps << "#{PROJECT_ROOT}/platforms/ios/GameTest/build/Debug-iphonesimulator/GameTest.app" if t.bins.find{ |s| s.to_s == 'GameTest.app' }
    deps << t.libfile("#{t.build_dir}/lib/libgame")
    deps
  }.flatten

  task :dependencies => depfiles do
  end

  # load custom rules
  task :game_prepare do
    # load "#{PROJECT_ROOT}/game/src/game_core.rake"
    load "#{PROJECT_ROOT}/game/lib/gamelib.rake"
    load "#{QGAME_ROOT}/tasks/libgame.rake"
    load "#{QGAME_ROOT}/tools/application.rake"

    Rake::Task["game:dependencies"].invoke
  end

  desc "build all targets, install (locally) in-repo"
  task :compile => :game_prepare do |args|
  end

  output_dir = "#{PROJECT_ROOT}/build"
  lib_name = 'libgame'

  task :ios_compile => ["#{output_dir}/ios_arm/lib/#{lib_name}.a", "#{output_dir}/ios_i386/lib/#{lib_name}.a"] do
    FileUtils.mkdir_p "#{output_dir}/ios/lib"
    FileUtils.sh "lipo -create -output #{output_dir}/ios/lib/#{lib_name}.a #{output_dir}/ios_arm/lib/#{lib_name}.a #{output_dir}/ios_i386/lib/#{lib_name}.a"
  end

  task :clean do
    Game.each_target do |t|
      FileUtils.rm_rf t.build_dir, { :verbose => $verbose }
    end
    FileUtils.rm_rf "#{output_dir}/ios/"
    FileUtils.rm_f depfiles, { :verbose => $verbose }
  end
end