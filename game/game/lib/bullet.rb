module TestGame
  class WorldObject; end

  class Bullet < WorldObject
    attr_accessor :velocity

    def initialize(args = {})
      @velocity = args[:velocity] || Vec3.new()
      @life = 10
      super(args)
    end

    def update
      @position += @velocity * Application.elapsed
      @life -= Application.elapsed
      self.destruct if @life <= 0
      super
    end
  end
end
