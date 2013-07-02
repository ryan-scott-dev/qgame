module QGame
  class Button < Sprite
    
    def initialize(args = {}, &block)
      super

      @texture_pressed = args[:texture_pressed]
      @on_pressed = block
    end

    def update
      super
    end

    def handle_mouse_up(event)
      mouse_pos = Vec2.new(event.mouse_button_x, event.mouse_button_y)

      if inside? mouse_pos
        self.instance_eval(&@on_pressed) unless @on_pressed.nil?
      end
    end

    def inside?(point)
      inverse_view = QGame::RenderManager.camera.view.invert
      screen_space_point = inverse_view.transform(point)

      return false if screen_space_point.nil?

      world_position = @position - (@scale * @offset)
      screen_space_point.x > world_position.x && screen_space_point.x < world_position.x + @scale.x &&
      screen_space_point.y > world_position.y && screen_space_point.y < world_position.y + @scale.y
    end
  end
end
