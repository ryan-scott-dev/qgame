module TestGame
  class WorldObject; end

  class Bullet < WorldObject
    include QGame::Collidable
    include TestGame::BoundingBox

    attr_accessor :velocity

    def initialize(args = {})
      @velocity = args[:velocity] || Vec3.new()
      @life = 1
      @bounds = AABB.new
      args[:scale] = Vec3.new(0.1)
      collides_as :projectile
      super(args)
    end

    def collided
      self.destruct
    end

    def damage
      10
    end

    def update
      @position += @velocity * Application.elapsed
      @life -= Application.elapsed
      self.destruct if @life <= 0

      update_bounds
      check_collisions

      super
    end
  end
end
