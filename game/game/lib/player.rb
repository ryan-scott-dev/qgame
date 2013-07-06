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
        if event.key == :left  
          move_left
        elsif event.key == :right
          move_right
        end

        if event.key == :up  
          jump
        end
      end
    end

    def move_right
      @velocity += 3
      loop_animation(:walk_right)
    end

    def move_left
      @velocity -= 3
      loop_animation(:walk_left)
    end

    def jump
      loop_animation(:jump)
    end

    def idle
      loop_animation(:idle)
    end

    def update
      @velocity = 3 if @velocity > 3
      @velocity = -3 if @velocity < -3

      @position.x += @velocity * Application.elapsed
      
      if @velocity == 0
        idle
      end

      @velocity -= Application.elapsed if @velocity > 0
      @velocity += Application.elapsed if @velocity < 0

      super
    end
  end
end
