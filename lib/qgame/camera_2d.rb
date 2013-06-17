module QGame
  class Camera2D
    attr_accessor :position
    
    def initialize(args = {})
      @position = args[:position] || Vec2.new
    end

    def update
    end

    def view
      Mat4.new(
        [1, 0, 0, -@position.x],
        [0, 1, 0, -@position.y],
        [0, 0, 1, 0],
        [0, 0, 0, 1])
    end
  end
end
