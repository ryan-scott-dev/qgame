module TestGame
  class WorldObject; end
  
  class TestCube < WorldObject
    @@model = nil
    @@shader = nil
    
    attr_accessor :position, :rotation, :scale, :texture, :parent
    alias_method :size, :scale

    def initialize(args = {})
      @texture = args[:texture]
      
      super({:shader => 'simple', :model => 'cube'}.merge(args))
    end

    def update
      @rotation.x += Application.elapsed
      @rotation.y += Application.elapsed
      @rotation.z += Application.elapsed
    end
  end
end
