module QGame
  class FollowCamera < Camera2D
    def initialize(args = {})
      @target = args[:target]

      super(args)
    end

    def center(position)
      @position = position - (QGame::RenderManager.screen_size / 2.0)
    end

    def update
      center(@target.position)
    end
  end
end
