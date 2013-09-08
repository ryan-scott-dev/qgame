
module QGame
  class Screen
  end

  class ConsoleOverlayScreen < Screen
    def self.enable
      Game::Application.current.on_event :key_down do |event|
        puts "Console" if QGame::Input.is_down? :dev_console
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


