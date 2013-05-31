require 'fileutils'

task :run, :args do |t, args|
  QGame::RunProject.run(args)
end

module QGame
  module RunProject
    def self.run(args)
      project_name = args[0]
            
      # ensure dependent libs are compiled
      # FileUtils.sh "./#{project_name}/build/mruby/minirake --quiet --rakefile=./#{project_name}/build/mruby/Rakefile"
      # Rake::Task["./#{project_name}/#{MRUBY_RAKE}:all"].invoke
      # compile qgame
      
      # compile custom game logic, linked with mruby and qgame and any other required libraries

      # run generated executable

      # Execute with mruby
      FileUtils.sh "./#{project_name}/build/mruby/bin/mruby ./#{project_name}/lib/application.rb"      
    end
  end
end