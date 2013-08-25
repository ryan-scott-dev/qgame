module QGame
  class Camera2D
    attr_accessor :position
    
    def initialize(args = {})
      @position = args[:position] || Vec2.new
    end

    def update
    end

    def bounds
      @bound = @position + Application.render_manager.screen_size
    end

    def view
      Mat4.new(
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [-@position.x, -@position.y, 0, 1])
    end
  end
end
