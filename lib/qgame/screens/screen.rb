module QGame
  class Screen
    @@screens = {}

    def self.find(screen_name)
      @@screens[screen_name]
    end

    def initialize(screen_name, &block)
      @name = screen_name
      @components = []
      @event_handlers = {}
      @event_catchers = []

      @configure = block
      
      @@screens[screen_name] = self
    end

    def build
      self.instance_eval(&@configure)
      self
    end

    def screen_width
      QGame::RenderManager.screen_width
    end

    def screen_height
      QGame::RenderManager.screen_height
    end

    def camera(type)
      case type
      when :fixed  
        QGame::RenderManager.camera = QGame::Camera2D.new
      end
    end

    def centered_args_from_texture(args)
      if args.has_key? :centered
        args[:position] = Vec2.new unless args.has_key? :position

        case args[:centered]
        when :horizontal
          args[:position].x = (screen_width / 2.0)
        when :vertical  
          args[:position].y = (screen_height / 2.0)
        when :both
          args[:position].x = (screen_width / 2.0)
          args[:position].y = (screen_height / 2.0)
        end

        args = args.reject!{ |k| k == :centered }
      end

      args
    end

    def image(texture_name, args = {})
      texture = QGame::AssetManager.texture(texture_name)

      args = centered_args_from_texture(args)

      new_image = QGame::Sprite.new({:texture => texture, :scale => texture.size}.merge(args))
      @components << new_image
      new_image
    end

    def button(texture_name, args = {}, &block)
      texture = QGame::AssetManager.texture(texture_name)
      texture_pressed = QGame::AssetManager.texture("#{texture_name}_pressed")

      args = centered_args_from_texture(args)

      new_button = QGame::Button.new({:texture => texture, :texture_pressed => texture_pressed, 
        :scale => texture.size}.merge(args), &block)
      
      on_event(:mouse_up) do |event|
        new_button.handle_mouse_up(event)
      end

      @components << new_button
      new_button
    end

    def update
      @components.each do |component|
        component.update
      end
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

    def handle_events(event_handler)
      @event_catchers << event_handler
    end

    def on_event(event_type, &block)
      @event_handlers[event_type] = [] unless @event_handlers.has_key? event_type
      @event_handlers[event_type] << block
    end
  end
end
