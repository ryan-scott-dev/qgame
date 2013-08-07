require 'fileutils'

PROJECT_ROOT = Dir.pwd

task :run, [:args] => :prepare_compile do |t, args|
  QGame::RunProject.run(COMPILE_PLATFORM.build_target, args)
end

module QGame
  module RunProject
    def self.run(desired_target, args)
      Game.targets[desired_target.to_s].run(args)
    end
  end
end