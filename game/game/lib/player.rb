module Game
  class Player < QGame::AnimatedSprite
    include QGame::EventHandler
    include QGame::Collidable
    include QGame::CollidableFast
    include Game::Jumpable

    MOVE_SPEED = 1
    MAX_SPEEDS = [160, 200, 240, 280, 320, 360]
    SPEED_WAIT = [5, 6, 7, 5, 5, 5]

    attr_accessor :falling, :score

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

      @velocity_x = 0
      @velocity_y = 0

      @score = 0
      @max_speed = MAX_SPEEDS.first
      @max_velocity_y = 500
      @speed_countdown = SPEED_WAIT.first
      @current_speed = 0
      @falling = true
      @jumping = false
      @jumping_countdown = 0
      @jumping_cooldown = 0.4
      @game_over = false
      @friction = 0
      super(args.merge(defaults))

      setup_events

      collides_as :player
      
      collides_with :enemies do |other|
        self.attacked_by(other)
      end

      collides_with :block do |other|
        self.stop_falling(other)
      end
    end

    def setup_events
      on_event :mouse_down do |event|
        jump
      end

      on_event :mouse_up do |event|
        release_jump
      end
    end

    def move_right
      @velocity_x += MOVE_SPEED
      loop_animation(:walk_right) unless @jumping
    end

    def move_left
      @velocity_x -= MOVE_SPEED
      loop_animation(:walk_left) unless @jumping
    end

    def stop_falling(other)
      unless @jumping 
        @velocity_y = 0

        # set the player bottom to the top of the other sprite
        @position.y = (other.top - (@offset.y * @scale.y))
        @falling = false
        stop_jumping
      end
    end

    def jump
      unless @jumping || @falling
        loop_animation(:jump)
      end

      super
    end

    def idle
      loop_animation(:idle)
    end

    def collect(collectable)
      @score += 1000
    end

    def game_over
      @game_over = true
      idle  

      @velocity_x = 0

      # Game::ScreenManager.transition_to(:main_menu)
    end

    def update

      @velocity_y += 400 * Application.elapsed if @falling || @jumping
      @velocity_y = @max_velocity_y if @velocity_y > @max_velocity_y

      unless @game_over
        move_right
        
        @score += 1
        @velocity_x = @max_speed if @velocity_x > @max_speed

        @speed_countdown -= Application.elapsed
        if @speed_countdown <= 0
          @current_speed += 1

          if @current_speed < MAX_SPEEDS.length
            @max_speed = MAX_SPEEDS[@current_speed]
            @speed_countdown = SPEED_WAIT[@current_speed]
          end
        end
      end
      
      update_jump

      @position.x += @velocity_x * Application.elapsed
      @position.y += @velocity_y * Application.elapsed

      @falling = true unless @jumping
      check_collisions

      game_over if @position.y > 350

      super
    end
  end
end
