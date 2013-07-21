load "#{MRUBY_ROOT}/tasks/mruby_build_gem.rake"
load "#{MRUBY_ROOT}/tasks/mruby_build_commands.rake"

load "#{MRUBY_ROOT}/tasks/mruby_build.rake"

module QGame 
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
    attr_reader :libqgame, :libmruby

    def initialize(name='host', &block)
      @name = name.to_s

      unless QGame.targets[@name]
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
        @build_dir = "#{QGAME_ROOT}/build/#{self.name}"

        @gems = MRuby::Gem::List.new
        @libqgame, @libmruby = [], []
        QGame.targets[@name] = self
      end

      MRuby::Build.current = QGame.targets[@name]
      QGame::Build.current = QGame.targets[@name]
      QGame.targets[@name].instance_eval(&block)

      QGame.targets[@name].instance_eval do
        gembox = File.expand_path("qgame.gembox", "#{QGAME_ROOT}/mrbgems")
        fail "Can't find gembox '#{gembox}'" unless File.exists?(gembox)
        MRuby::GemBox.config = self
        instance_eval File.read(gembox)
      end
    end

    def root
      QGAME_ROOT
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

    def build_sdl(args = {})
      FileUtils.mkdir_p "#{args[:output_dir]}/include/SDL2"
      FileUtils.mkdir_p "#{args[:output_dir]}/lib"
      
      if name.include?('ios')
        build_sdl_ios(args)
      else
        build_sdl_unix(args)
      end
    end

    def build_sdl_unix(args = {})
      FileUtils.cd args[:directory]
      FileUtils.sh "./configure --prefix=#{args[:output_dir]}"
      FileUtils.sh 'make clean'
      FileUtils.sh 'make'
      FileUtils.sh 'make install'
      FileUtils.cd args[:current_dir]
    end

    def build_sdl_ios(args = {})
      FileUtils.cp_r Dir.glob("#{args[:directory]}/include/**/*.h"), "#{args[:output_dir]}/include/SDL2"

      FileUtils.cp "#{args[:directory]}/include/SDL_config_iphoneos.h", "#{args[:directory]}/include/SDL_config.h"
      FileUtils.cd "#{args[:directory]}/Xcode-IOS/SDL"
      FileUtils.sh "xcodebuild clean"
      FileUtils.sh "xcodebuild build -target libSDL -arch #{args[:target].arch} -sdk #{args[:target].sdk}"

      FileUtils.cp "./build/Release-#{args[:target].sdk}/#{args[:library]}", "#{args[:output_file]}"
      
      FileUtils.cd args[:current_dir]
    end

    def build_freetype(args = {})
      FileUtils.mkdir_p "#{args[:output_dir]}/include/freetype"
      FileUtils.mkdir_p "#{args[:output_dir]}/lib"
      
      if name.include?('ios')
        build_freetype_ios(args)
      else
        build_freetype_unix(args)
      end
    end

    def build_freetype_unix(args = {})
      FileUtils.cd args[:directory]
      FileUtils.sh "./configure --prefix=#{args[:output_dir]} --without-zlib --without-bzip2 --without-png"
      FileUtils.sh 'make clean'
      FileUtils.sh 'make'
      FileUtils.sh 'make install'
      FileUtils.cd args[:current_dir]
    end

    def build_freetype_ios(args = {})
      target = args[:target]
      puts "PLATFORM: #{target.platform}"
      FileUtils.cd args[:directory]
      FileUtils.sh "./configure --prefix=#{args[:output_dir]} --host=arm-apple-darwin --without-zlib --without-bzip2 --without-png --enable-static=yes --enable-shared=no " +
        " CC=#{target.platform}/Developer/usr/bin/gcc" +
        " AR=#{target.platform}/Developer/usr/bin/ar" +
        " CFLAGS=\"#{target.cc.all_flags}\"" +
        " LDFLAGS=\"#{target.linker.all_flags}\""

      FileUtils.sh 'make clean'
      FileUtils.sh 'make'
      FileUtils.sh 'make install'
      FileUtils.cd args[:current_dir]
    end

    def build_sdl_library(args = {})
      if name.include?('ios')
        build_sdl_library_ios(args)
      else
        build_sdl_library_unix(args)
      end
    end

    def build_sdl_library_unix(args = {})
      FileUtils.cd args[:directory]
      FileUtils.sh "./configure --disable-sdltest --prefix=#{args[:output_dir]} --with-sdl-prefix=#{args[:output_dir]}"
      FileUtils.sh 'make clean'
      FileUtils.sh 'make'
      FileUtils.sh 'make install'
      FileUtils.cd args[:current_dir]
    end

    def build_sdl_library_ios(args ={})
      FileUtils.cp_r Dir.glob("#{args[:directory]}/*.h"), "#{args[:output_dir]}/include/SDL2"
      
      FileUtils.cd "#{args[:directory]}/Xcode-IOS"
      FileUtils.sh "xcodebuild clean"
      FileUtils.sh "xcodebuild build -arch #{args[:target].arch} -sdk #{args[:target].sdk}"
      FileUtils.cp "./build/Release-#{args[:target].sdk}/#{args[:library]}", "#{args[:output_file]}"
      FileUtils.cd args[:current_dir]
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

  end
end