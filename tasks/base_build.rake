load "#{MRUBY_ROOT}/tasks/mruby_build_gem.rake"
load "#{MRUBY_ROOT}/tasks/mruby_build_commands.rake"

module QGame
  module BaseBuild
    def setup_toolchain_defaults
      if ENV['OS'] == 'Windows_NT'
        @exts = MRuby::Build::Exts.new('.o', '.exe', '.a')
      else
        @exts = MRuby::Build::Exts.new('.o', '', '.a')
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

      @gems = MRuby::Gem::List.new
      @libmruby = []
    end

    def load_gembox(target, gembox)
      target.instance_eval do
        fail "Can't find gembox '#{gembox}'" unless File.exists?(gembox)
        MRuby::GemBox.config = self
        instance_eval File.read(gembox)
      end
    end

    def define_rules_relative_to_file(file)
      compilers.each do |compiler|
        if respond_to?(:enable_gems?) && enable_gems?
          compiler.defines -= %w(DISABLE_GEMS) 
        else
          compiler.defines += %w(DISABLE_GEMS) 
        end
        compiler.define_rules build_dir, File.expand_path(File.join(File.dirname(file), '..'))
      end
    end
  end
end
