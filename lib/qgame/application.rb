module QGame
  class Application
    def initialize
      @event_handlers = {}
    end

    def run(&block)
      SDL.init
      @window = Window.create("Test Window", 0, 0, 640, 480, [:shown, :opengl])

      block.call(self)
    end

    def on_event(event_type, &block)
      @event_handlers[event_type] = [] unless @event_handlers.has_key? event_type
      @event_handlers[event_type] << block
    end

    def handle_event(event_type, event)
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
      @window.destroy
      SDL.quit
    end
  end
end
