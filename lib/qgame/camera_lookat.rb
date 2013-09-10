module QGame
  class LookAtCamera
    attr_accessor :view, :position, :target, :up
    
    def initialize(args = {})
      @position = args[:position] || Vec3.new
      @target = args[:target] || Vec3.new(1)
      @up = args[:up] || Vec3.new(0, 1, 0)

      @view = Mat4.new

      update
    end

    def update
      z_axis = (@target - @position).normalize!
      x_axis = Vec3.cross(@up, z_axis).normalize!
      y_axis = Vec3.cross(z_axis, x_axis)

      @view.f11 = x_axis.x
      @view.f12 = x_axis.y
      @view.f13 = x_axis.z
      @view.f14 = -x_axis.dot(@position)

      @view.f21 = y_axis.x
      @view.f22 = y_axis.y
      @view.f23 = y_axis.z
      @view.f24 = -y_axis.dot(@position)

      @view.f31 = z_axis.x
      @view.f32 = z_axis.y
      @view.f33 = z_axis.z
      @view.f34 = -z_axis.dot(@position)
    end
  end
end
