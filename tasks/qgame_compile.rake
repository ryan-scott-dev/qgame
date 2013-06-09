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

  task :clean do
    QGame.each_target do |t|
      FileUtils.rm_rf t.build_dir, { :verbose => $verbose }
    end
    FileUtils.rm_f depfiles, { :verbose => $verbose }
  end
end