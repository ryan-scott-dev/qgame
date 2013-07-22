module Game
  class Coin < QGame::AnimatedSprite
    include QGame::Collidable
    include QGame::CollidableFast

    def initialize(args = {})
      defaults = {
        :texture => Game::AssetManager.texture('coin'), 
        :frame_size => Vec2.new(42),
        :frame_rate => 10
      }

      super(args.merge(defaults))

      collides_as(:collectable)

      collides_with :player do |other|
        other.collect(self)
        self.destruct
      end
    end

    def update
      check_collisions if @alive

      super
    end
  end
end
