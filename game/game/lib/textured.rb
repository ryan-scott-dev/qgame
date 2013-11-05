module TestGame
  module Textured
    attr_accessor :texture
    
    def initialize(args = {})
      @texture = args[:texture]
      super(args)
    end
  end
end
