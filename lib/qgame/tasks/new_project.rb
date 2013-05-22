require 'fileutils'

task :new, :args do |t, args|
  project_name = args[0]

  # Create the folder directory
  QGame::NewProject::create_folders project_name
  
  # Create vanilla project
  
  # Clone mruby & other deps
  QGame::NewProject::git_clone('git://github.com/mruby/mruby.git', "#{project_name}/build/mruby")
end

module QGame
  module NewProject
    def self.create_folders(project_name)
      FileUtils.mkdir_p "#{project_name}"
      FileUtils.mkdir_p "#{project_name}/assets"
      FileUtils.mkdir_p "#{project_name}/build"
      FileUtils.mkdir_p "#{project_name}/config"
      FileUtils.mkdir_p "#{project_name}/game"
      FileUtils.mkdir_p "#{project_name}/lib"
    end

    def self.git_clone(git_url, path)
      FileUtils.sh "git clone #{git_url} #{path}"
    end

  end
end