module TestGame
  module Fallable
    attr_accessor :falling

    def stop_falling(other)
      @velocity_y = 0

      # set the player bottom to the top of the other sprite
      @position.y = (other.top - (@offset.y * @scale.y)) + 1
      @falling = false
    end

    def update_falling
      @velocity_y += 400 * Application.elapsed if @falling
      @falling = true
    end

    def is_falling?
      (@falling) && @velocity_y <= 0
    end
  end
end
