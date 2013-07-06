module QGame
  module EventManager
    def event_handlers
      @event_handlers ||= {}
    end

    def event_catchers
      @event_catchers ||= []
    end

    def on_event(event_type, &block)
      puts event_handlers.inspect

      event_handlers[event_type] = [] unless event_handlers.has_key? event_type
      event_handlers[event_type] << block
    end

    def handle_events(event_handler)
      event_catchers << event_handler
    end

    def handle_event(event_type, event)
      event_catchers.each do |catcher|
        catcher.handle_event(event_type, event)
      end

      return nil unless event_handlers.has_key? event_type
      
      event_handlers[event_type].each do |handler|
        handler.call(event)
      end
    end

  end
end
