module $PROJ_NAME
  class Build < MRuby::Build
    def shared_setup(conf)
      toolchain :clang

      conf.gembox 'default'
    end
  end
end