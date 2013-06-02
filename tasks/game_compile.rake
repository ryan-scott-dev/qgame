namespace :game do
  depfiles = Game.targets.map { |n, t|
    [t.exefile("#{t.build_dir}/tools/main")]
  }.flatten

  task :dependencies => depfiles do
  end

  # load custom rules
  task :game_prepare do
    load "#{PROJECT_ROOT}/game/src/game_core.rake"
    # load "#{QGAME_ROOT}/tasks/libgame.rake"
    load "#{QGAME_ROOT}/tools/application.rake"

    Rake::Task["game:dependencies"].invoke
  end

  desc "build all targets, install (locally) in-repo"
  task :compile => :game_prepare do |args|
  end
end