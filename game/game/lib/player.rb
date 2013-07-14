module Game
  class Player < QGame::AnimatedSprite
    include QGame::EventHandler
    include QGame::Collidable
    include QGame::CollidableFast

    MOVE_SPEED = 10
    MAX_SPEEDS = [70, 100, 140, 180, 260, 300]
    SPEED_WAIT = [5, 6, 7, 5, 5, 5]

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
      @score = 0
      @max_speed = MAX_SPEEDS.first
      @speed_countdown = SPEED_WAIT.first
      @current_speed = 0

      super(args.merge(defaults))

      setup_events

      collides_as :player
      
      collides_with :enemies do |other|
        this.attacked_by(other)
      end
    end

    def setup_events
      on_event :key_down do |event|
        if event.key == :up  
          jump
        end
      end
    end

    def move_right
      @velocity += MOVE_SPEED
      loop_animation(:walk_right)
    end

    def move_left
      @velocity -= MOVE_SPEED
      loop_animation(:walk_left)
    end

    def jump
      loop_animation(:jump)
    end

    def idle
      loop_animation(:idle)
    end

    def collect(collectable)
      @score += 10
    end

    def update
      move_right
      
      @velocity = @max_speed if @velocity > @max_speed

      @position.x += @velocity * Application.elapsed

      @speed_countdown -= Application.elapsed
      if @speed_countdown <= 0
        @current_speed += 1

        if @current_speed < MAX_SPEEDS.length
          @max_speed = MAX_SPEEDS[@current_speed]
          @speed_countdown = SPEED_WAIT[@current_speed]
        end
      end
      check_collisions

      super
    end
  end
end
