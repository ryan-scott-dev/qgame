require 'fileutils'

task :new, :args do |t, args|
  QGame::NewProjectTask.run(args)
end

module QGame
  class NewProjectTask
    PROJECT_NAME_TOKEN = /\$PROJ_NAME/

    def initialize(args)
      @project_name = args[0]
    end

    def run
      create_from_skeleteon
      customise_created_skeleton

      # git_clone('git://github.com/mruby/mruby.git', "#{@project_name}/build/mruby")
    end

    def create_from_skeleteon
      FileUtils.cp_r "lib/structure/", "#{@project_name}/"
    end

    def customise_created_skeleton
      # Find a reserved word, and replace with the project name

      # foreach file in the skeleton
      files = Dir["#{@project_name}/**/*"].select{|file| File.file? file}
      files.each do |file|
        contents = ""

        File.open(file) { |f| contents = f.read }
        # replace every occurance of the reserved word with our own
        contents.gsub!(PROJECT_NAME_TOKEN, @project_name)
        File.open(file, "w+") { |f| f.write(contents) }
      end
    
    end

    def git_clone(git_url, path)
      FileUtils.sh "git clone #{git_url} #{path}"
    end

    def self.run(args)
      NewProjectTask.new(args).run
    end

  end
end