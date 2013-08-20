require 'fileutils'

task :new, :args do |t, args|
  QGame::NewProjectTask.run(args)
end

module QGame
  class NewProjectTask
    PROJECT_NAME_TOKEN = /\$PROJ_NAME/
    RESERVED_NAMES = %w[application]

    def initialize(args)
      @project_name = args[:args][0]

      validate_project_name
    end

    def run
      create_from_skeleteon
      customise_created_skeleton
    end

    def create_from_skeleteon
      FileUtils.cp_r "#{QGAME_ROOT}/lib/structure/", "#{@project_name}/"
    end

    def customise_created_skeleton
      # Find a reserved word, and replace with the project name

      # foreach file in the skeleton
      files = Dir["#{@project_name}/**/*"].select{|file| File.file? file}
      files.each do |file|
        contents = ""

        File.open(file) { |f| contents = f.read }
        # replace every occurance of the reserved word with our own
        contents.gsub!(PROJECT_NAME_TOKEN, app_const)
        File.open(file, "w+") { |f| f.write(contents) }
      end

    end

    def defined_app_const_base
      QGame.respond_to?(:application) && defined?(QGame::Application) &&
        QGame.application.is_a?(QGame::Application) && QGame.application.class.name.sub(/::Application$/, "")
    end

    alias :defined_app_const_base? :defined_app_const_base

    def app_name
      @app_name ||= (defined_app_const_base? ? defined_app_name : File.basename("#{@project_name}/")).tr(".", "_")
    end

    def defined_app_name
      defined_app_const_base.underscore
    end

    def app_const
      @app_const ||= defined_app_const_base || app_name.gsub(/\W/, '_').squeeze('_').camelize
    end

    def validate_project_name
      if app_const =~ /^\d/
        raise Error, "Invalid application name #{app_name}. Please give a name which does not start with numbers."
      elsif RESERVED_NAMES.include?(app_name)
        raise Error, "Invalid application name #{app_name}. Please give a name which does not match one of the reserved words."
      elsif Object.const_defined?(app_const)
        raise Error, "Invalid application name #{app_name}, constant #{app_const_base} is already in use. Please choose another application name."
      end
    end

    def self.run(args)
      NewProjectTask.new(args).run
    end

  end
end