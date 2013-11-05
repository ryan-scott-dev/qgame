module TestGame
  class WorldObject; end

  class TestPlayer < WorldObject
    include QGame::EventHandler

    def calculate_move_direction
      move_direction = Vec2.new
      if QGame::Input.is_down?(:move_forward)
        move_direction.x += 1
      end
      if QGame::Input.is_down?(:move_backward)
        move_direction.x -= 1
      end
      if QGame::Input.is_down?(:move_left)
        move_direction.y -= 1
      end
      if QGame::Input.is_down?(:move_right)
        move_direction.y += 1
      end
      move_direction.normalize! if (move_direction.x != 0 && move_direction.y != 0)
      move_direction
    end

    def update
      move_direction = calculate_move_direction

      @position.x += move_direction.x
      @position.z += move_direction.y

      super
    end

  end
end
