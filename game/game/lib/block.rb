module Game
  class Block < QGame::Sprite
    include QGame::Collidable
    include QGame::CollidableFast

    def initialize(args = {})
      super(args)

      collides_as :block
    end

  end
end
