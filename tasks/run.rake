require 'fileutils'

PROJECT_ROOT = Dir.pwd

task :run, [:args] do |t, args|
  QGame::RunProject.run(args)
end

module QGame
  module RunProject
    def self.run(args)
      desired_target = args[:target] || :host
      
      target = Game.targets[desired_target.to_s]
      run_dependency = target.exefile("#{target.build_dir}/tools/main")

      # run generated executable
      Rake::Task[run_dependency].invoke(args)
      
      # Execute with mruby
      FileUtils.sh run_dependency
    end
  end
end