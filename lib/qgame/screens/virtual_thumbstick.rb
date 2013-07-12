module QGame
  class VirtualThumbstick < Sprite
    
    def initialize(args = {})
      super

      @radius = args[:radius] || 100
      @held = false
      @origin_position = @position
    end

    def update
      super

      if @held
        mouse_pos = to_screen_space(Mouse.position)
        @position = mouse_pos
      end
    end

    def handle_mouse_down(event)
      mouse_pos = Vec2.new(event.mouse_button_x, event.mouse_button_y)

      if inside? mouse_pos
        @held = true
      end
    end

    def handle_mouse_up(event)
      @held = false
      @position = @origin_position
    end

    def to_screen_space(point)
      inverse_view = QGame::RenderManager.camera.view.invert
      screen_space_point = inverse_view.transform(point)

      screen_space_point
    end

    def inside?(point)
      screen_space_point = to_screen_space(point)

      return false if screen_space_point.nil?

      world_position = @position - (@scale * @offset)
      screen_space_point.x > world_position.x && screen_space_point.x < world_position.x + @scale.x &&
      screen_space_point.y > world_position.y && screen_space_point.y < world_position.y + @scale.y
    end
  end
end
