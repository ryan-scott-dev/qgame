module QGame
  class LookAtCamera
    attr_accessor :view, :position, :target, :up
    
    def initialize(args = {})
      @position = args[:position] || Vec3.new
      @target = args[:target] || Vec3.new
      @up = args[:up] || Vec3.new(0, 1, 0)

      @view = Mat4.new

      update
    end

    def update
      forward = (@target - @position).normalize!
      side = Vec3.cross(@up, forward).normalize!
      up = Vec3.cross(forward, side)

      @view.f11 = side.x
      @view.f21 = side.y
      @view.f31 = side.z
      @view.f41 = -(side.dot(@position))

      @view.f12 = up.x
      @view.f22 = up.y
      @view.f32 = up.z
      @view.f42 = -(up.dot(@position))

      @view.f13 = forward.x
      @view.f23 = forward.y
      @view.f33 = forward.z
      @view.f43 = -(forward.dot(@position))
    end
  end
end
