module QGame
  class ScreenManager
    @@current_screen = nil
    @@next_screen = nil

    def self.current=(screen)
      @@current_screen = screen
    end

    def self.current
      @@current_screen
    end

    def self.next_screen=(screen)
      @@next_screen = screen
    end

    def self.next_screen
      @@next_screen
    end

    def self.handle_event(event_type, event)
      current.handle_event(event_type, event) unless current.nil?
    end

    def self.transition_to(screen_name, args = {})
      screen = QGame::Screen.find(screen_name)

      raise "Unable to find the screen #{screen_name}" if screen.nil?

      self.next_screen = screen.build
      self.next_screen.pause

      if !self.current.nil? && self.current.has_transition?(:out)
        
        self.current.start_transition(:out, {:to => self.next_screen}) do
        
          self.current = self.next_screen
          self.current.resume
        
          self.next_screen = nil
        end
        self.next_screen
      else
        self.current = self.next_screen
        self.current.resume
        self.next_screen = nil
      
        self.current
      end
    end

    def self.update
      self.current.update unless self.current.nil?
      self.next_screen.update unless self.next_screen.nil?
    end

    def self.submit_render
      self.current.submit_render unless self.current.nil?
      self.next_screen.submit_render unless self.next_screen.nil?
    end

    def self.define_screen(screen_name, &block)
      QGame::Screen.new(screen_name, &block)
    end
  end
end
