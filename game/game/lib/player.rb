module Game
  class Player < QGame::AnimatedSprite
    include QGame::EventHandler
    include QGame::Collidable
    include QGame::CollidableFast

    MOVE_SPEED = 1
    MAX_SPEEDS = [100, 140, 160, 190, 220, 260]
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
      @max_velocity_y = 380
      @speed_countdown = SPEED_WAIT.first
      @current_speed = 0
      @falling = true
      @jumping = false
      @jumping_countdown = 0
      @jumping_cooldown = 1
      @game_over = false
      @friction = 0
      super(args.merge(defaults))

      setup_events

      collides_as :player
      
      collides_with :enemies do |other|
        self.attacked_by(other)
      end

      collides_with :block do |other|
        self.stop_falling
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

    def stop_falling
      unless @jumping 
        @falling = false
        @velocity_y = 0
      end
    end

    def jump
      @jump_held = true
      unless @jumping || @falling
        @jumping = true
        @velocity_y = -200
        loop_animation(:jump)
      end
    end

    def release_jump
      @jump_held = false
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

      Game::ScreenManager.transition_to(:main_menu)
    end

    def update

      @velocity_y += 200 * Application.elapsed if @falling || @jumping
      @velocity_y = @max_velocity_y if @velocity_y > @max_velocity_y

      unless @game_over
        move_right
        
        @score += 1
        @velocity_x = @max_speed if @velocity_x > @max_speed

        if @jumping
          @velocity_y -= 120 * Application.elapsed
          @velocity_y = -@max_velocity_y if @velocity_y < -@max_velocity_y

          @jumping_countdown += Application.elapsed

          unless @jump_held
            if @velocity_y < -189
              @jumping = false
            end
          end

          if @jumping_countdown > @jumping_cooldown
            @jumping = false
            @falling = true
            @jump_held = false
            @jumping_countdown = 0
          end
        end

        @position.x += @velocity_x * Application.elapsed
        @position.y += @velocity_y * Application.elapsed

        @speed_countdown -= Application.elapsed
        if @speed_countdown <= 0
          @current_speed += 1

          if @current_speed < MAX_SPEEDS.length
            @max_speed = MAX_SPEEDS[@current_speed]
            @speed_countdown = SPEED_WAIT[@current_speed]
          end
        end

        game_over if @position.y > 350
      end
     
      @falling = true unless @jumping
      check_collisions

      super
    end
  end
end
