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
      point.x > @position.x && point.x < @position.x + @scale.x &&
      point.y > @position.y && point.y < @position.y + @scale.y
    end
  end
end
