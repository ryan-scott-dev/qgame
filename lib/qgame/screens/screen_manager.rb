module QGame
  class ScreenManager
    @@current_screen = nil

    def self.current=(screen)
      @@current_screen = screen
    end

    def self.current
      @@current_screen
    end

    def self.handle_event(event_type, event)
      current.handle_event(event_type, event) unless current.nil?
    end

    def self.transition_to(screen_name)
      self.current = QGame::Screen.find(screen_name).build
    end

    def self.update
      self.current.update unless self.current.nil?
    end
  end
end
