
module QGame
  class Screen
  end

  class ConsoleOverlayScreen < Screen
    @@overlay = nil

    def self.toggle_overlay
      if @@overlay.nil?
        @@overlay = Game::Application.screen_manager.current.overlay(:console_overlay) 
      else
        Game::Application.screen_manager.current.remove_overlay(:console_overlay)
        @@overlay.destruct
        @@overlay = nil
      end
    end

    def self.enable
      Game::Application.current.on_event :key_down do |event|
        toggle_overlay if QGame::Input.is_down? :dev_console
      end

      Game::Application.screen_manager.define_screen(:console_overlay) do
        camera(:fixed)

        console(:default_text => '', :font => './assets/fonts/Vera.ttf', :font_size => 10, 
          :position => Vec2.new(100, 100), :input_offset => Vec2.new(2, 3),
          :background => 'textinput', :background_focus => 'textinput_focus')
      end
    end
  end
end


