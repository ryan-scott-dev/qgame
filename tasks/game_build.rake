load "#{MRUBY_ROOT}/tasks/mruby_build_gem.rake"
load "#{MRUBY_ROOT}/tasks/mruby_build_commands.rake"

module Game
  class << self
    def targets
      @targets ||= {}
    end

    def each_target(&block)
      @targets.each do |key, target|
        target.instance_eval(&block)
      end
    end
  end

  class Build < MRuby::Build
    attr_reader :libgame, :libmruby
    include QGame::BaseBuild

    def initialize(name='host', &block)
      @name = name.to_s
      @build_dir = "#{PROJECT_ROOT}/build/#{self.name}"
      @gem_clone_dir = "#{PROJECT_ROOT}/gems"
      
      unless Game.targets[@name]
        setup_toolchain_defaults

        @bins = %w(main)
        @libgame = []
        
        Game.targets[@name] = self
      end

      MRuby::Build.current = Game.targets[@name]
      Game::Build.current = Game.targets[@name]
      Game.targets[@name].instance_eval(&block)

      load_gembox(Game.targets[@name], File.expand_path("game.gembox", "#{PROJECT_ROOT}/gems"))
    end

    def enable_gems?
      true
    end

    def root
      PROJECT_ROOT
    end

    def output_application
      exefile("#{build_dir}/tools/main")
    end

    def define_rules
      define_rules_relative_to_file(__FILE__)
    end

    def run(args)
      # run generated executable
      Rake::Task['compile'].invoke(args)

      # Execute with mruby
      FileUtils.sh("#{output_application} #{args[:args].flatten.join(' ')}")
    end

    def copy_assets?
      true
    end
  end

  class BuildiOS < Build
    def platform(platform = nil)
      @platform ||= platform
    end

    def sdk_path(sdk_path = nil)
      @sdk_path ||= sdk_path
    end

    def sdk_version(sdk_version = nil)
      @sdk_version ||= sdk_version
    end

    def sdk(sdk = nil)
      @sdk ||= sdk
    end

    def arch(arch = nil)
      @arch ||= arch
    end
    
    def initialize(name, &block)
      super

      @bins << 'GameTest.app'
    end

    def output_application
      "#{PROJECT_ROOT}/platforms/ios/GameTest/build/Debug-iphonesimulator/GameTest.app"
    end

    def run(args)
      Rake::Task['compile'].invoke(args)

      FileUtils.sh "#{IOS_SIM_EXEC} launch #{output_application}"
    end
    
    def copy_assets?
      false
    end
  end
end