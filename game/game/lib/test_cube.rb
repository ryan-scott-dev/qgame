module TestGame
  class WorldObject; end
  module Textured; end
    
  class TestCube < WorldObject
    include Textured

    attr_accessor :position, :rotation, :scale, :parent
    alias_method :size, :scale

    def initialize(args = {})
      super({:shader => 'simple', :model => 'cube'}.merge(args))
    end

    def update
      @rotation.x += Application.elapsed
      @rotation.y += Application.elapsed
      @rotation.z += Application.elapsed

      super
    end
  end
end
