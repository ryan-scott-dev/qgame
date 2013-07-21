module Game
  class Player < QGame::AnimatedSprite
    include QGame::EventHandler
    include QGame::Collidable
    include QGame::CollidableFast

    MOVE_SPEED = 1
    MAX_SPEEDS = [70, 100, 140, 180, 260, 300]
    SPEED_WAIT = [5, 6, 7, 5, 5, 5]

    attr_accessor :falling

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
      @falling = true
      @jumping = false
      @jumping_countdown = 0
      @jumping_cooldown = 1

      super(args.merge(defaults))

      setup_events

      collides_as :player
      
      collides_with :enemies do |other|
        self.attacked_by(other)
      end

      collides_with :block do |other|
        self.falling = false
      end
    end

    def setup_events
      on_event :mouse_down do |event|
        jump
      end
    end

    def move_right
      @velocity += MOVE_SPEED
      loop_animation(:walk_right) unless @jumping
    end

    def move_left
      @velocity -= MOVE_SPEED
      loop_animation(:walk_left) unless @jumping
    end

    def jump
      unless @jumping || @falling
        @jumping = true

        loop_animation(:jump)
      end
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
      @position.y += 140 * Application.elapsed if @falling

      if @jumping 
        @position.y -= 180 * Application.elapsed
        @jumping_countdown += Application.elapsed

        if @jumping_countdown > @jumping_cooldown
          @jumping = false
          @falling = true
          @jumping_countdown = 0
        end
      end

      @speed_countdown -= Application.elapsed
      if @speed_countdown <= 0
        @current_speed += 1

        if @current_speed < MAX_SPEEDS.length
          @max_speed = MAX_SPEEDS[@current_speed]
          @speed_countdown = SPEED_WAIT[@current_speed]
        end
      end

      @falling = true unless @jumping
      check_collisions

      super
    end
  end
end
