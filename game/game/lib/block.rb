module TestGame
  class Block < QGame::Sprite
    include QGame::Collidable
    include QGame::CollidableAbove

    def initialize(args = {})
      super(args)

      @collidable = args[:collidable].nil? ? true : args[:collidable]
      collides_as :block if @collidable
    end

  end
end
