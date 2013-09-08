module QGame
  class TextInput
    attr_accessor :position, :parent, :transparency

    def initialize(args = {})
      args = args.except(:parent)
      @parent = args[:parent] || nil
      @local_transparency = args[:transparency] || 1.0
      calculate_transparency
      
      @text_display = QGame::Text.new({:text => args[:default_text], :z_index => 1.0, :parent => self}.merge(args))

      texture = QGame::AssetManager.texture(args[:background])
      @background = QGame::Sprite.new({:texture => texture, :scale => texture.size, 
        :z_index => 0.2, :screen_space => true, :parent => self}.merge(args))
      @buffer = ''
    end

    def transparency
      @absolute_transparency
    end

    def calculate_transparency
      @absolute_transparency = @local_transparency
      @absolute_transparency *= @parent.transparency if @parent
    end

    def update
      @text_display.update
      @background.update
    end

    def submit_render
      @text_display.submit_render
      @background.submit_render
    end
    
    def focus_input
      SDL.start_text_input
    end

    def blur_input
      SDL.stop_text_input
    end

    def remove(component)
    end

    def handle_key_down(event)
      case event.key
      when :backspace
        @buffer = @buffer[0...-1]
        @text_display.text = @buffer
      end
    end

    def destruct
      @text_display.destruct
      @background.destruct

      if self.parent
        self.parent.remove(self)
        self.parent = nil
      end
    end

    def handle_editing(event)
    end

    def handle_text_input(event)
      @buffer += event.text
      @text_display.text = @buffer
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
