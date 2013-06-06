module QGame
  class Application
    def initialize
      @event_handlers = {}
    end

    def run(&block)
      start
      
      instance_eval(&block)
    end

    def start
      SDL.init
      SDL.set_gl_version(3, 2)
      @window = SDL::Window.create("Test Window", 0, 0, 640, 480, [:shown, :opengl])
      @context = @window.create_gl_context
      GLEW.init
    end

    def on_event(event_type, &block)
      @event_handlers[event_type] = [] unless @event_handlers.has_key? event_type
      @event_handlers[event_type] << block
    end

    def handle_event(event_type, event)
      return nil unless @event_handlers.has_key? event_type
      
      @event_handlers[event_type].each do |handler|
        handler.call(event)
      end
    end

    def handle_events
      while event = SDL.poll_event
        handle_event(event.type, event)
      end
    end

    def quit
      @context.destroy
      @window.destroy
      SDL.quit
    end
  end
end
