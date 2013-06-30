module QGame
  class Application
    @@config = {}

    def initialize
      @event_handlers = {}
      @event_catchers = []
    end

    def run(&block)
      start

      instance_eval(&block)
    end
    
    def self.conf
      @@config
    end

    def self.current
      @@current
    end

    def self.configure(&block)
      instance_eval(&block)
    end

    def title
      Application.conf[:title]
    end

    def window_flags
      Application.conf[:window_flags]
    end

    def start_width
      Application.conf[:start_size][0]
    end

    def start_height
      Application.conf[:start_size][1]
    end

    def start
      SDL.init
      SDL.set_gl_version(3, 2)
      @window = SDL::Window.create(title, 0, 0, start_width, start_height, window_flags)
      @context = @window.create_gl_context

      Game::RenderManager.resize_window(@window.width, @window.height)

      AssetManager.register_asset_loader("shaders", ShaderAssetLoader.new)
      AssetManager.register_asset_loader("models", ModelAssetLoader.new)
      AssetManager.register_asset_loader("textures", TextureAssetLoader.new)
      AssetManager.register_asset_loader("sounds", SoundAssetLoader.new)
      AssetManager.load

      @@current = self
    end

    def on_event(event_type, &block)
      @event_handlers[event_type] = [] unless @event_handlers.has_key? event_type
      @event_handlers[event_type] << block
    end

    def handle_events(event_handler)
      @event_catchers << event_handler
    end

    def handle_event(event_type, event)
      @event_catchers.each do |catcher|
        catcher.handle_event(event_type, event)
      end

      return nil unless @event_handlers.has_key? event_type
      
      @event_handlers[event_type].each do |handler|
        handler.call(event)
      end
    end

    def process_events
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
