module QGame
  class Screen
    @@screens = {}

    include QGame::EventManager

    def self.find(screen_name)
      @@screens[screen_name]
    end

    def initialize(screen_name, &block)
      @built = false
      @name = screen_name
      @components = []

      @configure = block
      
      @@screens[screen_name] = self
    end

    def build
      self.instance_eval(&@configure) unless @built
      @built = true
      self
    end

    def screen_width
      QGame::RenderManager.screen_width
    end

    def screen_height
      QGame::RenderManager.screen_height
    end

    def screen_size
      @screen_size ||= Vec2.new(screen_width, screen_height)
    end

    def remove(entity)
      @components.delete(entity)
    end

    def camera(type, args = {})
      case type
      when :fixed  
        QGame::RenderManager.camera = QGame::Camera2D.new(args)
      when :follow
        QGame::RenderManager.camera = QGame::FollowCamera.new(args)
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

    def overlay(screen_name)
      @parent_screen = QGame::Screen.find(screen_name).build
      handle_events @parent_screen
    end

    def dynamic_text(args = {}, &block)
      new_text = QGame::DynamicText.new(args, &block)
      @components << new_text
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

    def joystick(texture_name, args = {})
      texture = QGame::AssetManager.texture(texture_name)
      texture_base = "#{texture_name}_base"

      args = centered_args_from_texture(args)
      
      base_image = image(texture_base, args)
      new_joystick = QGame::VirtualThumbstick.new({:texture => texture, :radius => base_image.scale.x}.merge(args))
      
      on_event(:mouse_up) do |event|
        new_joystick.handle_mouse_up(event)
      end

      on_event(:mouse_down) do |event|
        new_joystick.handle_mouse_down(event)
      end

      @components << new_joystick
      new_joystick
    end

    def update
      @components.each do |component|
        component.update
      end

      QGame::RenderManager.camera.update

      @parent_screen.update unless @parent_screen.nil?
    end
  end
end
