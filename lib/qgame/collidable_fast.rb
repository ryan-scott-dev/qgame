module QGame
  module CollidableFast
    
    def has_collided?(other)
      self_position = self.transformed_position
      other_position = other.transformed_position

      other_position.x + other.scale.x > self_position.x && other_position.x < self_position.x + @scale.x &&
      other_position.y + other.scale.y > self_position.y && other_position.y < self_position.y + @scale.y
    end

  end
end
