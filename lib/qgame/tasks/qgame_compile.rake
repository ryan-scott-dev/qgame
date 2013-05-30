namespace :qgame do
  depfiles = QGame.targets.map { |n, t|
    [t.libfile("#{t.build_dir}/lib/libqgame")]
  }.flatten

  task :dependencies => depfiles do
  end

  # load custom rules
  task :qgame_prepare do
    load "#{QGAME_ROOT}/lib/qgame/src/qgame_core.rake"
    load "#{QGAME_ROOT}/lib/qgame/mrblib/mrblib.rake"
    load "#{QGAME_ROOT}/lib/qgame/tasks/libqgame.rake"

    Rake::Task["qgame:dependencies"].invoke
  end

  desc "build all targets, install (locally) in-repo"
  task :compile => :qgame_prepare do |args|
  end
end