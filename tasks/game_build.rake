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

    def initialize(name='host', &block)
      @name = name.to_s

      unless Game.targets[@name]
        if ENV['OS'] == 'Windows_NT'
          @exts = Exts.new('.o', '.exe', '.a')
        else
          @exts = Exts.new('.o', '', '.a')
        end

        @file_separator = '/'
        @cc = MRuby::Command::Compiler.new(self, %w(.c))
        @cxx = MRuby::Command::Compiler.new(self, %w(.cc .cxx .cpp))
        @objc = MRuby::Command::Compiler.new(self, %w(.m))
        @asm = MRuby::Command::Compiler.new(self, %w(.S .asm))
        @linker = MRuby::Command::Linker.new(self)
        @archiver = MRuby::Command::Archiver.new(self)
        @yacc = MRuby::Command::Yacc.new(self)
        @gperf = MRuby::Command::Gperf.new(self)
        @git = MRuby::Command::Git.new(self)
        @mrbc = MRuby::Command::Mrbc.new(self)
        @build_dir = "#{PROJECT_ROOT}/build/#{self.name}"
        @gem_clone_dir = "#{PROJECT_ROOT}/gems"
        
        @bins = %w(main)
        @gems, @libgame, @libmruby = MRuby::Gem::List.new, [], []
        Game.targets[@name] = self
      end

      MRuby::Build.current = Game.targets[@name]
      Game::Build.current = Game.targets[@name]
      Game.targets[@name].instance_eval(&block)

      Game.targets[@name].instance_eval do
        gembox = File.expand_path("game.gembox", "#{PROJECT_ROOT}/gems")
        fail "Can't find gembox '#{gembox}'" unless File.exists?(gembox)
        MRuby::GemBox.config = self
        instance_eval File.read(gembox)
      end
    end

    def root
      PROJECT_ROOT
    end

    def define_rules
      compilers.each do |compiler|
        if respond_to?(:enable_gems?) && enable_gems?
          compiler.defines -= %w(DISABLE_GEMS)
        else
          compiler.defines += %w(DISABLE_GEMS)
        end

        compiler.define_rules build_dir, File.expand_path(File.join(File.dirname(__FILE__), '..'))
      end
    end

    def run(args)
      run_dependency = exefile("#{build_dir}/tools/main")
      
      # run generated executable
      Rake::Task['compile'].invoke(args)

      # Execute with mruby
      FileUtils.sh("#{run_dependency} #{args[:args].flatten.join(' ')}")
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

    def run(args)
      Rake::Task['compile'].invoke(args)

      app = "#{PROJECT_ROOT}/platforms/ios/GameTest/build/Debug-iphonesimulator/GameTest.app"
      
      FileUtils.sh "#{IOS_SIM_EXEC} launch #{app}"
    end
  end
end