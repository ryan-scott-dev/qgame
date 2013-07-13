module QGame
  class VirtualThumbstick < Sprite
    
    def initialize(args = {})
      super

      @radius = args[:radius] || 100
      @held = false
      @origin_position = @position
      @deadzone_radius = @radius / 2.0

      @virtual_gamepad = QGame::Input.fetch_mapping(:virtual_gamepad).input_manager
    end

    def update
      super

      left_pressed = false
      right_pressed = false

      if @held
        mouse_pos = to_screen_space(Mouse.position)
        offset = (mouse_pos - @origin_position)
        length = offset.length
        direction = offset.normalize
        @position = @origin_position + direction * Math.min(length, @radius)
        
        left_pressed = offset.x < @deadzone_radius
        right_pressed = offset.x > @deadzone_radius
      end
      
      @virtual_gamepad.change_input_state(:left, left_pressed)
      @virtual_gamepad.change_input_state(:right, right_pressed)     
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
      point
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
