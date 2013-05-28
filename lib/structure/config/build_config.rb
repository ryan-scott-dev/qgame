module $PROJ_NAME
  class Build < MRuby::Build
    attr_reader :libqgame

    def initialize(name='host', &block)
      super(name, block)

      @libqgame = []
    end

    def shared_setup(conf)
      toolchain :clang

      conf.gembox 'default'
    end
  end
end