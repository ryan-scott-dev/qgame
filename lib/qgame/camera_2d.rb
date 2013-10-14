module QGame
  class Camera2D
    attr_accessor :position, :view
    
    def initialize(args = {})
      @position = args[:position] || Vec2.new
      @view = Mat4.new

      update
    end

    def update
      @view.f41 = -@position.x
      @view.f42 = -@position.y
    end

    def bounds
      @bound = @position + Application.render_manager.screen_size
    end

    def to_world_space(screen_point)
      return screen_point + @position
    end
  end
end
