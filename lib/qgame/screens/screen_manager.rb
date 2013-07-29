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
      new_screen = QGame::Screen.find(screen_name).build
      old_screen = self.current
      self.current = new_screen

      if !old_screen.nil? && old_screen.has_transition?(:out)
        old_screen.transition_out_to(new_screen)
      end
    end

    def self.update
      self.current.update unless self.current.nil?
    end

    def self.submit_render
      self.current.submit_render unless self.current.nil?
    end
  end
end
