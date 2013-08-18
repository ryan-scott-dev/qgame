load "#{MRUBY_ROOT}/tasks/mruby_build_gem.rake"
load "#{MRUBY_ROOT}/tasks/mruby_build_commands.rake"

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
    include QGame::BaseBuild

    def initialize(name='host', &block)
      @name = name.to_s
      @build_dir = "#{QGAME_ROOT}/build/#{self.name}"
      @gem_clone_dir = "#{QGAME_ROOT}/build/mrbgems"

      unless QGame.targets[@name]
        setup_toolchain_defaults

        @libqgame = []

        QGame.targets[@name] = self
      end

      MRuby::Build.current = QGame.targets[@name]
      QGame::Build.current = QGame.targets[@name]
      QGame.targets[@name].instance_eval(&block)

      load_gembox(QGame.targets[@name], File.expand_path("qgame.gembox", "#{QGAME_ROOT}/mrbgems"))
    end

    def root
      QGAME_ROOT
    end

    def define_rules
      define_rules_relative_to_file(__FILE__)
    end

    def build_sdl(args = {})
      FileUtils.mkdir_p "#{args[:output_dir]}/include/SDL2"
      FileUtils.mkdir_p "#{args[:output_dir]}/lib"

      if COMPILE_PLATFORM.is_ios?
        build_sdl_ios(args)
      elsif COMPILE_PLATFORM.is_win?
        build_sdl_win(args)
      else
        build_sdl_unix(args)
      end
    end

    def build_sdl_win(args = {})
      args[:library] = args[:library].sub(/lib/, '')

      FileUtils.cd args[:directory]
      FileUtils.sh 'vcvars32.bat'
      FileUtils.sh "devenv ./VisualC/SDL_VS2012.sln /Build"
      FileUtils.cp "./VisualC/SDL/Win32/Debug/#{args[:library]}", "#{args[:output_file]}"

      FileUtils.cd args[:current_dir]
    end

    def build_sdl_unix(args = {})
      FileUtils.cd args[:directory]
      FileUtils.sh './autogen.sh'
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

      if COMPILE_PLATFORM.is_ios?
        build_freetype_ios(args)
      elsif COMPILE_PLATFORM.is_win?
        build_freetype_win(args)
      else
        build_freetype_unix(args)
      end
    end

    def build_freetype_win(args = {})
      args[:library] = args[:library].sub(/lib/, '')

      FileUtils.cd args[:directory]
      FileUtils.sh 'vcvars32.bat'
      FileUtils.sh "devenv ./builds/win32/vc2012/freetype.sln /Build"
      FileUtils.cp "./objs/win32/vc2012/freetype250_D.lib", "#{args[:output_file]}"

      FileUtils.cd args[:current_dir]
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
      if COMPILE_PLATFORM.is_ios?
        build_sdl_library_ios(args)
      elsif COMPILE_PLATFORM.is_win?
        build_sdl_library_win(args)
      else
        build_sdl_library_unix(args)
      end
    end

    def build_sdl_library_win(args = {})
      args[:library] = args[:library].sub(/lib/, '')

      FileUtils.cd args[:directory]
      FileUtils.sh 'vcvars32.bat'
      FileUtils.sh "devenv ./VisualC/#{args[:library_name]}_VS2012.sln /Build"
      output_file = Dir.glob("./VisualC/**/#{args[:library]}").first
      FileUtils.cp output_file, "#{args[:output_file]}"

      FileUtils.cd args[:current_dir]
    end

    def build_sdl_library_unix(args = {})
      FileUtils.cd args[:directory]
      FileUtils.sh './autogen.sh'
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