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
      offset = Mat4.new
      offset.f41 = -@position.x
      offset.f42 = -@position.y
      offset.f43 = -@position.z

      view_temp = Mat4.new

      forward = (@target - @position).normalize!
      side = Vec3.cross(@up, forward).normalize!
      up = Vec3.cross(forward, side)

      view_temp.f11 = side.x
      view_temp.f21 = side.y
      view_temp.f31 = side.z

      view_temp.f12 = up.x
      view_temp.f22 = up.y
      view_temp.f32 = up.z
      
      view_temp.f13 = -forward.x
      view_temp.f23 = -forward.y
      view_temp.f33 = -forward.z

      @view = view_temp * offset
    end
  end
end
