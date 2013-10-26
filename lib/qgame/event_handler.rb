module QGame
  module EventHandler
    def event_handlers
      @event_handlers ||= {}
    end

    def on_event(event_type, &block)
      event_handlers[event_type] ||= []
      event_handlers[event_type] << block
    end

    def handle_event(event_type, event)
      call_event_handler(event_type, event)
    end

    def call_event_handler(event_type, event)
      return nil unless event_handlers.has_key? event_type
      return nil if event_handlers[event_type].nil?
      
      event_handlers[event_type].each do |handler|
        handler.call(event)

        break if event.handled
      end
    end

  end
end
