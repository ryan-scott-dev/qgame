module TestGame
  class WorldObject; end

  class TestPlayer < WorldObject
    include QGame::EventHandler

    def initialize(args = {})
      @direction = Vec3.new(0, 0, 1)
      @shoot_cooldown = 0

      super(args)
    end

    def calculate_move_direction
      move_direction = Vec3.new
      if QGame::Input.is_down?(:move_forward)
        move_direction.x += 1
      end
      if QGame::Input.is_down?(:move_backward)
        move_direction.x -= 1
      end
      if QGame::Input.is_down?(:move_left)
        move_direction.z -= 1
      end
      if QGame::Input.is_down?(:move_right)
        move_direction.z += 1
      end
      move_direction.normalize! if (move_direction.x != 0 && move_direction.z != 0)
      @world_mat.transform(move_direction)
    end

    def calculate_facing_angle
      mouse_position = QGame::MouseInput.mouse_position
      mouse_ray = QGame::Application.render_manager.screen_to_world_ray(mouse_position)
      
      if mouse_ray
        mouse_world_position = mouse_ray.intersection_point_with_plane(Vec3.new(0, 1, 0))
        target_direction = (mouse_world_position - @position).normalize
        rotation = Math.atan2(target_direction.z, target_direction.x)
        return rotation
      end
      0
    end

    def move_speed
      10
    end

    def shoot
      return unless @shoot_cooldown <= 0

      @shoot_cooldown = 1
      bullet_pos = Vec3.new(1, 0, 0)
      bullet_pos = @world_mat.transform(bullet_pos)

      @parent.add(Bullet.new(:position => @position, :velocity => bullet_pos * 30))
    end

    def update
      facing_angle = calculate_facing_angle
      @rotation.y = facing_angle
      move_direction = calculate_move_direction

      @position += move_direction * move_speed * Application.elapsed

      # shoot  
      @shoot_cooldown -= Application.elapsed
      
      super
    end

  end
end
