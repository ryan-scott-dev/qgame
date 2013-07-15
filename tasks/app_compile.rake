namespace :game do
  depfiles = Game.targets.map { |n, t|
    deps = []
    deps << t.exefile("#{t.build_dir}/tools/main") if t.bins.find{ |s| s.to_s == 'main' }
    deps << "#{PROJECT_ROOT}/platforms/ios/GameTest/build/Debug-iphonesimulator/GameTest.app" if t.bins.find{ |s| s.to_s == 'GameTest.app' }
    deps
  }.flatten

  task :app_dependencies => depfiles do
  end

  # load custom rules
  task :app_prepare do
    load "#{QGAME_ROOT}/tools/application.rake"

    Rake::Task["game:app_dependencies"].invoke
  end

  task :app_compile => :app_prepare do |args|
  end

  task :clean do
    Game.each_target do |t|
      FileUtils.rm_rf t.build_dir, { :verbose => $verbose }
    end
    FileUtils.rm_f depfiles, { :verbose => $verbose }
  end
end