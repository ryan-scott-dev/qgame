module QGame
  class Screen
    @@screens = {}

    include QGame::EventManager

    attr_accessor :name, :paused, :camera, :transparency
    
    def self.find(screen_name)
      @@screens[screen_name]
    end

    def self.has_screen?(screen_name)
      @@screens.has_key? screen_name
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

    def reset
      build
    end

    def build
      destruct

      self.instance_eval(&@configure)
      @built = true
      self
    end

    def transparency=(val)
      self.instance_variable_set('@transparency', val)

      @components.each do |component|
        component.calculate_transparency
      end
    end

    def screen_width
      Application.render_manager.screen_width
    end

    def screen_height
      Application.render_manager.screen_height
    end

    def screen_size
      @screen_size ||= Vec2.new(screen_width, screen_height)
    end

    def remove(entity)
      entity.parent = nil
      @components.delete(entity)
    end

    def add(entity)
      entity.parent = self
      @components << entity
    end

    def pause
      @paused = true
    end

    def resume
      @paused = false
      Application.render_manager.camera = @camera
    end

    def camera(type, args = {})
      case type
      when :fixed  
        @camera = Application.render_manager.camera = QGame::Camera2D.new(args)
      when :follow
        @camera = Application.render_manager.camera = QGame::FollowCamera.new(args)
      end
    end

    def screen_center
      Vec2.new((screen_height / 2.0), (screen_width / 2.0))
    end

    def center_horizontal_position
      Vec2.new(screen_center.x, 0)
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

    def destruct
      @components.clear
      
      destroy_parent_screen      
    end

    def destroy_parent_screen
      if @parent_screen
        @parent_screen.destruct
        @parent_screen = nil
      end
    end

    def overlay(screen_name)
      if @parent_screen.nil?
        if screen_name.nil?
          destroy_parent_screen
        else
          @parent_screen = QGame::Screen.find(screen_name).build
          handle_events @parent_screen
        end

        return @parent_screen
      else
        return @parent_screen.overlay(screen_name)
      end
    end

    def remove_overlay(screen_name)
      if @parent_screen
        if @parent_screen.name == screen_name
          destroy_parent_screen
        else 
          @parent_screen.remove_overlay(screen_name)
        end
      end
    end

    def dynamic_text(args = {}, &block)
      new_text = QGame::DynamicText.new(args, &block)
      add(new_text)
    end

    def image(texture_name, args = {})
      texture = QGame::AssetManager.texture(texture_name)

      args = centered_args_from_texture(args)

      new_image = QGame::Sprite.new({:texture => texture, :scale => texture.size}.merge(args))
      add(new_image)
      new_image
    end

    def button(texture_name, args = {}, &block)
      texture = QGame::AssetManager.texture(texture_name)
      texture_pressed = QGame::AssetManager.texture("#{texture_name}_pressed")

      # args = centered_args_from_texture(args)

      new_button = QGame::Button.new({:screen_space => true, :texture => texture, :texture_pressed => texture_pressed, 
        :scale => texture.size, :mode => :on_release}.merge(args), &block)
      new_button.position += center_horizontal_position if args[:centered] && args[:centered] == :horizontal

      on_event(:mouse_up) do |event|
        new_button.handle_mouse_up(event)
      end

      on_event(:mouse_down) do |event|
        new_button.handle_mouse_down(event)
      end

      add(new_button)
      new_button
    end

    def text(text, args = {}) 

      new_text = QGame::Text.new({:text => text}.merge(args))
      new_text.position += center_horizontal_position if args[:centered] && args[:centered] == :horizontal
      add(new_text)
      new_text
    end

    def text_input(args = {})
      new_text_input = QGame::TextInput.new(args)

      on_event(:mouse_up) do |event|
        new_text_input.handle_mouse_up(event)
      end

      on_event(:key_down) do |event|
        new_text_input.handle_key_down(event)
      end

      on_event(:text_input) do |event|
        new_text_input.handle_text_input(event)
      end

      on_event(:text_editing) do |event|
        new_text_input.handle_editing(event)
      end

      add(new_text_input)
      new_text_input
    end

    def ticker_graph(args = {}, &block)
      new_graph = QGame::TickerGraph.new(args, &block)
      add(new_graph)
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

      add(new_joystick)
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

        Application.render_manager.camera.update  
      end

      @parent_screen.update unless @parent_screen.nil?

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
