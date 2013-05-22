require 'fileutils'

task :new, :args do |t, args|
  QGame::NewProject.run(args)
end

module QGame
  module NewProject
    def self.run(args)
      project_name = args[0]

      # Create the folder directory
      QGame::NewProject::create_folders project_name
      
      # Create vanilla project
      QGame::NewProject.create_vanilla_project project_name

      # Clone mruby & other deps
      # QGame::NewProject::git_clone('git://github.com/mruby/mruby.git', "#{project_name}/build/mruby")
    end

    def self.create_folders(project_name)
      FileUtils.mkdir_p "#{project_name}"
      FileUtils.cp_r "./lib/structure/", "#{project_name}/"
    end

    def self.create_vanilla_project(project_name)
    end

    def self.git_clone(git_url, path)
      FileUtils.sh "git clone #{git_url} #{path}"
    end
  end
end