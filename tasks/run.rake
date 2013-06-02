require 'fileutils'

PROJECT_ROOT = Dir.pwd

task :run, [:args] => :compile do |t, args|
  QGame::RunProject.run(args)
end

module QGame
  module RunProject
    def self.run(args)
      # run generated executable

      # Execute with mruby
      FileUtils.sh "./build/host/tools/main"
    end
  end
end