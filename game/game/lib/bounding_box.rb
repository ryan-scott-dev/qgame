module TestGame
  module BoundingBox
    attr_accessor :bounds

    def has_collided?(other)
      return unless other.alive && self.alive
      @bounds.intersect?(other.bounds) if @bounds
    end

    def update_bounds
      @bounds.transform(@world_mat) if @bounds
    end

  end
end
