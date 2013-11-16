module QGame
  class Ray
    attr_accessor :position, :direction

    def initialize(position, direction)
      @position = position
      @direction = direction
    end

    def find_position(distance)
      return nil unless distance != false

      @position + @direction * Vec3.new(distance)
    end

    def intersection_point_with_plane(plane_normal)
      intersection_distance = intersect_with_plane(plane_normal)
      find_position(intersection_distance)
    end

    def intersect_with_plane(plane_normal)
      denom = plane_normal.dot(@direction)
      numerator = -plane_normal.dot(@position)
      
      return false if denom.abs < 0.0000001

      intersect = numerator / denom
      return false if intersect < 0
  
      return intersect;
    end
  end
end
