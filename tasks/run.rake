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
      FileUtils.sh ".#{PROJECT_ROOT}/bin/dev_application"
    end
  end
end