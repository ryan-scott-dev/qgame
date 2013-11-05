module TestGame
  class WorldObject; end
  
  class TestPlane < WorldObject
    attr_accessor :texture
    
    def initialize(args = {})
      @texture = args[:texture]
      size = 20
      args[:position] ||= Vec3.new(-size/2, 0, -size/2)
      args[:rotation] ||= Vec3.new(Math::PI / 2, 0, 0)
      args[:scale] ||= Vec3.new(size)

      super({:shader => 'simple', :model => 'triangle'}.merge(args))
    end
  end
end
