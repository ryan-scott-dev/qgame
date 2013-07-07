module Game
  class Player < QGame::AnimatedSprite
    include QGame::EventHandler

    def initialize(args = {})
      defaults = {
        :texture => Game::AssetManager.texture('robot'), 
        :frame_size => Vec2.new(51, 93),
        :frame_rate => 10,
        :animations => {
          :walk_left => (8..15),
          :walk_right => (16..23),
          :jump => (4..7),
          :idle => (0..0)
        },
        :default_animation => :idle
      }

      @velocity = 0
      super(args.merge(defaults))

      setup_events
    end

    def setup_events
      on_event :key_down do |event|
        if event.key == :up  
          jump
        end
      end
    end

    def move_right
      @velocity += 10
      loop_animation(:walk_right)
    end

    def move_left
      @velocity -= 10
      loop_animation(:walk_left)
    end

    def jump
      loop_animation(:jump)
    end

    def idle
      loop_animation(:idle)
    end

    def update

      if Game::Input.is_down?(:move_left)
        move_left
      end
      if Game::Input.is_down?(:move_right)
        move_right
      end

      @velocity = 10 if @velocity > 10
      @velocity = -10 if @velocity < -10

      @position.x += @velocity * Application.elapsed        

      if @velocity == 0
        idle
      end

      vel_falloff = Application.elapsed * 20
      if @velocity > 0
        vel_falloff = @velocity.abs if @velocity.abs > vel_falloff
        @velocity -= vel_falloff 
      end

      if @velocity < 0
        vel_falloff = @velocity.abs if @velocity.abs > vel_falloff
        @velocity += vel_falloff
      end

      super
    end
  end
end
