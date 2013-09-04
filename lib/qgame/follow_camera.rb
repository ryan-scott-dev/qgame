module QGame
  class FollowCamera < Camera2D
    def initialize(args = {})
      @target = args[:target]

      super(args)
    end

    def center(position)
      @position = position - (Application.render_manager.screen_size / 2.0)
    end

    def update
      center(@target.position)

      super
    end
  end
end
