require 'fileutils'

PROJECT_ROOT = Dir.pwd

task :run, [:args] => :prepare_compile do |t, args|
  QGame::RunProject.run(:host, args)
end

namespace :run do
  task :ios, [:args] => :prepare_compile do |t, args|
    QGame::RunProject.run(:ios_i386, args)
  end
end

module QGame
  module RunProject
    def self.run(desired_target, args)
      Game.targets[desired_target.to_s].run(args)
    end
  end
end