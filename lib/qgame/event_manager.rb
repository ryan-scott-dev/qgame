module QGame
  module EventManager
    include EventHandler

    def event_catchers
      @event_catchers ||= []
    end

    def handle_events(event_handler)
      event_catchers << event_handler
    end

    def handle_event(event_type, event)
      event_catchers.each do |catcher|
        catcher.handle_event(event_type, event)
      end

      call_event_handler(event_type, event)
    end

  end
end
