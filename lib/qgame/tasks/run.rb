require 'fileutils'

task :run, :args do |t, args|
  QGame::RunProject.run(args)
end

module QGame
  module RunProject
    def self.run(args)
      project_name = args[0]

      # ensure libs are compiled
      FileUtils.sh "./#{project_name}/build/mruby/minirake --quiet --rakefile=./#{project_name}/build/mruby/Rakefile"

      

    end
  end
end