module QGame
  class Screen
    @@screens = {}

    include QGame::EventManager

    attr_accessor :name, :paused, :camera, :transparency
    
    def self.find(screen_name)
      @@screens[screen_name]
    end

    def initialize(screen_name, &block)
      @built = false
      @name = screen_name
      @components = []
      @transitions = {}
      @animations = []
      @transparency = 1.0

      @configure = block
      
      @@screens[screen_name] = self
    end

    def build
      @components.clear

      self.instance_eval(&@configure)
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

    def add(entity)
      @components << entity
    end

    def pause
      @paused = true
    end

    def resume
      stop_handling_events @parent_screen unless @parent_screen.nil?
      @parent_screen = nil

      @paused = false
      QGame::RenderManager.camera = @camera
    end

    def camera(type, args = {})
      case type
      when :fixed  
        @camera = QGame::RenderManager.camera = QGame::Camera2D.new(args)
      when :follow
        @camera = QGame::RenderManager.camera = QGame::FollowCamera.new(args)
      end
    end

    def screen_center
      Vec2.new((screen_height / 2.0), (screen_width / 2.0))
    end

    def center_position_from_size(size)
      Vec2.new((screen_height / 2) - (size.x / 2), (screen_width / 2) - (size.y / 2))
    end

    def centered_args_from_texture(args)
      if args.has_key? :centered
        args[:position] = Vec2.new unless args.has_key? :position

        case args[:centered]
        when :horizontal
          args[:position].x = screen_center.x
        when :vertical  
          args[:position].y = screen_center.y
        when :both
          args[:position] = screen_center
        end

        args = args.reject!{ |k| k == :centered }
      end

      args
    end

    def overlay(screen_name)
      if screen_name.nil?
        @parent_screen = nil
      else
        @parent_screen = QGame::Screen.find(screen_name).build
        handle_events @parent_screen
      end
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

      new_button = QGame::Button.new({:screen_space => true, :texture => texture, :texture_pressed => texture_pressed, 
        :scale => texture.size, :mode => :on_release}.merge(args), &block)
      
      on_event(:mouse_up) do |event|
        new_button.handle_mouse_up(event)
      end

      on_event(:mouse_down) do |event|
        new_button.handle_mouse_down(event)
      end

      @components << new_button
      new_button
    end

    def text(text, args = {}) 

      new_text = QGame::Text.new({:text => text}.merge(args))
      new_text.position = center_position_from_size(new_text.size)
      # new_text.position += Vec2.new(-new_text.size.x / 2, 0)
      @components << new_text
      new_text
    end

    def joystick(texture_name, args = {})
      texture = QGame::AssetManager.texture(texture_name)
      texture_base = "#{texture_name}_base"

      args = centered_args_from_texture(args)
      args[:screen_space] = true

      base_image = image(texture_base, args)
      new_joystick = QGame::VirtualThumbstick.new({:texture => texture, :radius => base_image.scale.x / 2.0}.merge(args))
      
      on_event(:mouse_up) do |event|
        new_joystick.handle_mouse_up(event)
      end

      on_event(:mouse_down) do |event|
        new_joystick.handle_mouse_down(event)
      end

      @components << new_joystick
      new_joystick
    end

    def has_transition?(transition_name)
      @transitions.has_key? transition_name
    end

    def transition(transition_name, &block)
      @transitions[transition_name] = block
    end

    def start_transition(transition_name, args = {}, &callback)
      args[:callback] = callback

      self.instance_exec(args, &@transitions[transition_name])
    end
    
    def animate(property_name)
      new_animation = PropertyAnimation.new(self, property_name)
      @animations << new_animation
      new_animation
    end

    def remove_animation(animation)
      @animations.delete(animation)
    end

    def update
      unless @paused
        @components.each do |component|
          component.update
        end

        QGame::RenderManager.camera.update

        @parent_screen.update unless @parent_screen.nil?
      end

      @animations.each do |animation|
        animation.update
      end
    end

    def submit_render
      @components.each do |component|
        component.submit_render
      end

      @parent_screen.submit_render unless @parent_screen.nil?
    end
  end
end
