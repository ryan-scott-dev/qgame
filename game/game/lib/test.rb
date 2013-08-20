module TestGame
  class Test < QGame::AnimatedSprite
    include QGame::Collidable
    include QGame::CollidableFast
    
    include TestGame::Fallable
    include TestGame::Jumpable

    def initialize(args = {})
      defaults = {
        :texture => QGame::AssetManager.texture('test_sprite'), 
        :frame_size => Vec2.new(60, 60),
        :frame_rate => 20,
      }

      @velocity_x = 0
      @velocity_y = 0

      @max_velocity_y = 500
      @falling = true
      @jumping = false
      @jumping_countdown = 0
      @jumping_cooldown = 0.3

      super(args.merge(defaults))

      collides_as :player
      
      collides_with :block do |other|
        self.stop_falling(other)
      end
    end

    def update
      jump
      release_jump
      
      update_jumping
      update_falling
      
      @velocity_x = @max_speed if @velocity_x > @max_speed
      @position.x += @velocity_x * Application.elapsed

      @velocity_y = @max_velocity_y if @velocity_y > @max_velocity_y
      @position.y += @velocity_y * Application.elapsed

      check_collisions

      super
    end
  end
end
