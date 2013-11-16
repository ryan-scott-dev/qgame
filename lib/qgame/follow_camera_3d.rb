module QGame
  class FollowCamera3D < LookAtCamera
    def initialize(args = {})
      @follow = args[:follow]
      @offset_direction = args[:offset_direction]
      @offset_magnitude = args[:offset_magnitude]

      super(args)
    end

    def update_position(position)
      @target = position
      @position = @target + (@offset_direction * @offset_magnitude)
    end

    def update
      update_position(@follow.position)

      super
    end
  end
end
