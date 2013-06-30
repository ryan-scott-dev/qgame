module QGame
  class Button < Sprite
    
    def initialize(args = {})
      super
      @texture_pressed = args[:texture_pressed]
    end

    def update
      super
    end

    def handle_mouse_up(event)
      mouse_pos = Vec2.new(event.mouse_button_x, event.mouse_button_y)

      if inside? mouse_pos
        puts "Mouse pressed the button"
      else
        puts "Mouse didn't press the button (#{mouse_pos.x}, #{mouse_pos.y})"
      end
    end

    def inside?(point)
      point.x > @position.x && point.x < @position.x + @scale.x &&
      point.y > @position.y && point.y < @position.y + @scale.y
    end
  end
end
