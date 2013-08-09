module QGame
  class TextInput
    attr_accessor :position, :parent

    def initialize(args = {})
      @text_display = QGame::Text.new({:text => args[:default_text], :z_index => 1.0}.merge(args))

      texture = QGame::AssetManager.texture(args[:background])
      @background = QGame::Sprite.new({:texture => texture, :scale => texture.size, :z_index => 0.2}.merge(args))
      @buffer = ''
    end

    def update
      @text_display.update
      @background.update
    end

    def submit_render
      @text_display.submit_render
      # @background.submit_render
    end
    
    def focus_input
      SDL.start_text_input
    end

    def blur_input
      SDL.stop_text_input
    end

    def handle_key_down(event)
      case event.key
      when :backspace
        @buffer = @buffer[0...-1]
        @text_display.text = @buffer
      when :return
        @buffer = ''
        @text_display.text = @buffer
      end
    end

    def handle_editing(event)
    end

    def handle_text_input(event)
      @buffer += event.text
      @text_display.text = @buffer
    end
    
    def calculate_transparency
    end

    def handle_mouse_up(event)
      mouse_pos = Vec2.new(event.mouse_button_x, event.mouse_button_y)

      if @background.inside?(mouse_pos)
        focus_input 
      else
        blur_input
      end
    end
  end
end
