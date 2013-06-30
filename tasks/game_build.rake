load "#{MRUBY_ROOT}/tasks/mruby_build_gem.rake"
load "#{MRUBY_ROOT}/tasks/mruby_build_commands.rake"

load "#{MRUBY_ROOT}/tasks/mruby_build.rake"

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
    attr_reader :libgame

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

        @bins = %w(main)
        @gems, @libgame = MRuby::Gem::List.new, []
        Game.targets[@name] = self
      end

      MRuby::Build.current = Game.targets[@name]
      Game::Build.current = Game.targets[@name]
      Game.targets[@name].instance_eval(&block)
    end

    def root
      PROJECT_ROOT
    end

    def build_dir
      "#{PROJECT_ROOT}/build/#{self.name}"
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
      FileUtils.sh run_dependency
    end
  end

  class BuildiOS < Build
    def run(args)
      Rake::Task['compile'].invoke(args)

      dependencies = []
      dependencies << libfile("#{build_dir}/lib/libgame")
      dependencies << "#{build_dir}/tools/main.c"

      run_dependency = "#{PROJECT_ROOT}/platforms/ios/GameTest/GameTest.xcodeproj"
      dependencies.each do |dependency|
        Rake::Task[dependency].invoke(args)
      end

      Rake::Task['ios_sim:build'].invoke
      

      FileUtils.sh "xcodebuild -project #{run_dependency} -configuration Debug -target \"GameTest\" -sdk iphonesimulator6.1"
      app = "#{PROJECT_ROOT}/platforms/ios/GameTest/build/Release-iphonesimulator/GameTest.app"
      unless File.exists? app
        puts "Unable to locate the app at: #{app}"
      end
      FileUtils.sh "#{IOS_SIM_EXEC} launch #{app}"
    end
  end
end