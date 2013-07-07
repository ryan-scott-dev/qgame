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
      move_dir = :right
      loop_animation(:walk_right)
    end

    def move_left
      move_dir = :left
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
      elsif Game::Input.is_down?(:move_right)
        move_right
      else
        idle
      end

      # @position.x += 10 * Application.elapsed        
      # @velocity = 30 if @velocity > 30
      # @velocity = -30 if @velocity < -30

      # if @velocity == 0
      #   idle
      # end

      # @velocity -= Application.elapsed if @velocity > 0
      # @velocity += Application.elapsed if @velocity < 0

      super
    end
  end
end
