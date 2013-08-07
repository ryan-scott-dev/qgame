task :analyse, [:args] => :prepare_compile do |t, args|
  QGame::AnalyseProjectTask.analyse(COMPILE_PLATFORM.build_target, args)
end

module QGame
  module AnalyseProjectTask
    def self.analyse(desired_target, args)
      args[:args] << 'analyse'
      
      Game.targets[desired_target.to_s].run(args)
    end
  end
end