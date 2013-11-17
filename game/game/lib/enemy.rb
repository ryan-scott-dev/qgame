module TestGame
  class WorldObject; end

  class Enemy < WorldObject
    include QGame::EventHandler

    def initialize(args = {})
      @direction = Vec3.new(0, 0, 1)
      
      args[:scale] = Vec3.new(1, 2, 1)
      super(args)
    end

  end
end
