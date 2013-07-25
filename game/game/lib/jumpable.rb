module Game
  module Jumpable

    def jump
      @jump_held = true

      unless @jumping || @falling
        @jumping = true
        @jumping_countdown = 0
        @velocity_y = -320
      end
    end

    def release_jump
      @jump_held = false
    end

    def stop_jumping
      @jumping = false
      @jump_held = false
    end

    def update_jump
      if @jumping
        @velocity_y -= 200 * Application.elapsed
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
    end
  end
end
