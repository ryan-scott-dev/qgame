module QGame
  class Button < Sprite
    
    def initialize(args = {}, &block)
      super

      @texture_pressed = args[:texture_pressed]
      @mode = args[:mode] || :on_release
      if args.has_key?(:text)
        @text = Text.new(args[:text].merge({:parent => self}))
        text_size = @text.size
        @text_offset = Vec2.new(-text_size.x / 2, text_size.y / 2)
        @text.position = self.position + @text_offset
      end
      @on_pressed = block
    end

    def position=(newPosition)
      super
      @text.position = newPosition + @text_offset unless @text.nil?
    end

    def transparency
      @absolute_transparency
    end

    def submit_render
      super
      @text.submit_render unless @text.nil?
    end

    def handle_mouse_down(event)
      return unless @mode == :on_press
      mouse_pos = Vec2.new(event.mouse_button_x, event.mouse_button_y)

      if inside? mouse_pos
        self.instance_eval(&@on_pressed) unless @on_pressed.nil?
      end
    end

    def handle_mouse_up(event)
      return unless @mode == :on_release
      mouse_pos = Vec2.new(event.mouse_button_x, event.mouse_button_y)

      if inside? mouse_pos
        self.instance_eval(&@on_pressed) unless @on_pressed.nil?
      end
    end
  end
end
