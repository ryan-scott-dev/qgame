namespace :game do
  depfiles = Game.targets.map { |n, t|
    deps = []
    deps << t.exefile("#{t.build_dir}/tools/main") if t.bins.find{ |s| s.to_s == 'main' }
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

  task :clean do
    Game.each_target do |t|
      FileUtils.rm_rf t.build_dir, { :verbose => $verbose }
    end
    FileUtils.rm_f depfiles, { :verbose => $verbose }
  end
end