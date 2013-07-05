module Game
  class Coin < QGame::AnimatedSprite
    def initialize(args = {})
      defaults = {
        :texture => Game::AssetManager.texture('coin'), 
        :frame_size => Vec2.new(42),
        :frame_rate => 0.3
      }

      super(args.merge(defaults))
    end
  end
end
