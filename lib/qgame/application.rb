module QGame
  module EventHandler
  end

  module EventManager
    include EventHandler
  end

  class Application
    @@config = {}
    @@profile = nil

    attr_accessor :elapsed
    
    include QGame::EventManager

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

    def self.profile
      @@profile ||= Profile.current
    end

    def self.configure(&block)
      instance_eval(&block)
    end

    def self.render_manager
      QGame::RenderManager
    end

    def self.screen_manager
      QGame::ScreenManager
    end

    def self.scenario_manager
      QGame::ScenarioManager
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

    def self.elapsed
      Application.current.elapsed
    end

    def setup_input
      QGame::Input.setup(Application.conf[:input])
    end

    def start
      SDL.init
      SDL.set_gl_version(3, 2)
      @window = SDL::Window.create(title, 0, 0, start_width, start_height, window_flags)
      @context = @window.create_gl_context
      setup_input

      Application.render_manager.resize_window(@window.width, @window.height)

      AssetManager.register_asset_loader("shaders", ShaderAssetLoader.new)
      AssetManager.register_asset_loader("models", ModelAssetLoader.new)
      AssetManager.register_asset_loader("textures", TextureAssetLoader.new)
      AssetManager.register_asset_loader("sounds", SoundAssetLoader.new)
      AssetManager.load

      @@current = self
    end


    def process_events
      while event = SDL.poll_event
        handle_event(event.type, event)
      end
    end

    def quit
      @running = false
    end

    def cleanup
      @context.destroy
      @window.destroy
      SDL.quit
    end
  end
end
