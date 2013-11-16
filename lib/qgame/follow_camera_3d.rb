module QGame
  class FollowCamera3D < LookAtCamera
    def initialize(args = {})
      @follow = args[:follow]
      @offset = args[:offset]

      super(args)
    end

    def update_position(position)
      @target = position
      @position = @target + @offset
    end

    def update
      update_position(@follow.position)

      super
    end
  end
end
