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
      @view.look_at(@position, @target, @up)
    end
  end
end
