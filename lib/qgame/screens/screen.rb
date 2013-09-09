module QGame
  class Screen
    @@screens = {}

    include QGame::EventManager
    include QGame::Buildable
    include QGame::BuildableHelpers

    include QGame::Composite

    attr_accessor :name, :paused, :transparency
    
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

    def transparency=(val)
      self.instance_variable_set('@transparency', val)

      @components.each do |component|
        component.calculate_transparency
      end
    end

    def screen_size
      @screen_size ||= Vec2.new(screen_width, screen_height)
    end

    def pause
      @paused = true
    end

    def resume
      @paused = false
      Application.render_manager.camera = @camera
    end

    def destruct
      destruct_children

      event_handlers.clear

      destroy_parent_screen      
    end

    def destroy_parent_screen
      if @parent_screen
        stop_handling_events @parent_screen
        
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
        update_children

        @camera.update unless @camera.nil?
      end

      @parent_screen.update unless @parent_screen.nil?

      @animations.each do |animation|
        animation.update
      end
    end

    def submit_render
      submit_render_children

      @parent_screen.submit_render unless @parent_screen.nil?
    end
  end
end
