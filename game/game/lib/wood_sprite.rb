module Game
  class WoodSprite < QGame::Sprite
    def initialize(args = {})
      @timestep = 0

      super(args.merge({:texture => Game::AssetManager.texture('wood')}))
    end

    def update
      @timestep += 0.01
      @rotation = @timestep

      super
    end
  end
end
