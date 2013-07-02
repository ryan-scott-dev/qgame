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

      @configure = block
      
      @@screens[screen_name] = self
    end

    def build
      self.instance_eval(&@configure)
      self
    end

    def image(texture_name, args = {})
      texture = QGame::AssetManager.texture(texture_name)
      new_image = QGame::Sprite.new({:texture => texture, :scale => texture.size}.merge(args))
      @components << new_image
      new_image
    end

    def button(texture_name, args = {}, &block)
      texture = QGame::AssetManager.texture(texture_name)
      texture_pressed = QGame::AssetManager.texture("#{texture_name}_pressed")

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
      return nil unless @event_handlers.has_key? event_type
      
      @event_handlers[event_type].each do |handler|
        handler.call(event)
      end
    end

    def on_event(event_type, &block)
      @event_handlers[event_type] = [] unless @event_handlers.has_key? event_type
      @event_handlers[event_type] << block
    end
  end
end
