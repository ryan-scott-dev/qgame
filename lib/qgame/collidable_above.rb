module QGame
  module CollidableAbove

    OVERLAP = 10
    
    def has_collided?(other)
      self_position = @position - (@scale * @offset)
      other_position = other.position - (other.scale * other.offset)

      other_position.x + other.scale.x > self_position.x && other_position.x < self_position.x + @scale.x &&
      other_position.y + other.scale.y > self_position.y && other_position.y + other.scale.y < self_position.y + OVERLAP
    end

  end
end
