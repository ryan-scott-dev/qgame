module TestGame
  class AABB
    attr_accessor :min, :max

    def initialize(args = {})
      @min = @local_min = args[:min] || Vec3.new
      @max = @local_max = args[:max] || Vec3.new(1)
    end

    def min=(val)
      @min = @local_min = val
    end

    def max=(val)
      @max = @local_max = val
    end

    def intersect?(other)
      return  self.max.x > other.min.x && 
              self.min.x < other.max.x &&
              self.max.y > other.min.y &&
              self.min.y < other.max.y &&
              self.max.z > other.min.z &&
              self.min.z < other.max.z
    end

    def transform(matrix)
      @min = matrix.transform(@local_min)
      @max = matrix.transform(@local_max)
    end
  end
end
