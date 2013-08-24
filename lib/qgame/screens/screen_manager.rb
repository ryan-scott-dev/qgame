module QGame
  class ScreenManager
    @@current_screen_stack = []
    @@next_screen_stack = []

    def self.current=(screen)
      @@current_screen_stack = screen
    end

    def self.current_screen_stack
      @@current_screen_stack
    end

    def self.current
      current_screen_stack.first
    end

    def self.next_screen_stack=(screen)
      @@next_screen_stack = screen
    end

    def self.next_screen_stack
      @@next_screen_stack
    end

    def self.handle_event(event_type, event)
      current.handle_event(event_type, event) unless current.nil?
    end

    def self.transition_to(screen_name)
      next_screen = QGame::Screen.find(screen_name).build
      next_screen.pause
      next_screen_stack << next_screen

      if !current_screen_stack.empty? && current_screen_stack.any? {|screen| screen.has_transition?(:out) }
        current.start_transition(:out, {:to => next_screen}) do
          current_screen_stack.clear
          next_screen_stack.each do |screen|
            current_screen_stack << screen
            screen.resume
          end
          next_screen_stack.clear
        end
        next_screen
      else
        current_screen_stack.clear
        next_screen_stack.each do |screen|
          current_screen_stack << screen
          screen.resume
        end
        next_screen_stack.clear
        
        self.current
      end
    end

    def self.update
      current_screen_stack.each do |screen|
        screen.update
      end

      next_screen_stack.each do |screen|
        screen.update
      end
    end

    def self.submit_render
      current_screen_stack.each do |screen|
        screen.submit_render
      end

      next_screen_stack.each do |screen|
        screen.submit_render
      end
    end

    def self.define_screen(screen_name, &block)
      QGame::Screen.new(screen_name, &block)
    end
  end
end
