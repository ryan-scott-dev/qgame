module TestGame
  class WorldObject; end

  class TestPlayer < WorldObject
    include QGame::EventHandler

    def initialize(args = {})
      @direction = Vec3.new(0, 0, 1)
      super(args)
    end

    def calculate_move_direction
      move_direction = Vec3.new
      if QGame::Input.is_down?(:move_forward)
        move_direction.z += 1
      end
      if QGame::Input.is_down?(:move_backward)
        move_direction.z -= 1
      end
      if QGame::Input.is_down?(:move_left)
        move_direction.x -= 1
      end
      if QGame::Input.is_down?(:move_right)
        move_direction.x += 1
      end
      move_direction.normalize! if (move_direction.x != 0 && move_direction.z != 0)
      @world_mat.transform(move_direction)
    end

    def update
      move_direction = calculate_move_direction

      @position += move_direction

      super
    end

  end
end
