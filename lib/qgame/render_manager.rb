module QGame
  class RenderManager
    @@camera = nil
    @@projection = nil
    @@width = 0
    @@height = 0
    @@fov = 60
    @@near = 0.1
    @@far = 1000.0

    @@render_batch = ModelRenderBatch.new
    @@submitted_entities = {}
    @@render_duration = Time.now
    @@projection_mode = :orthogonal

    def self.camera=(camera)
      @@camera = camera
    end

    def self.camera
      @@camera
    end

    def self.orthogonal
      @@projection_mode = :orthogonal
      @@projection = Mat4.orthogonal(0, @@width, 0, @@height, 0, 1)
    end

    def self.orthogonal?
      @@projection_mode == :orthogonal
    end

    def self.perspective
      @@projection_mode = :perspective
      @@projection = Mat4.perspective(@@fov, @@width / @@height, @@near, @@far)
    end

    def self.perspective?
      @@projection_mode == :perspective
    end

    def self.render
      start_time = Time.now
      
      GL.blend_alpha_transparency
      
      @@render_batch.render
      @@submitted_entities.clear
      
      GL.blend_opaque

      @@render_duration = Time.now - start_time
    end

    def self.render_duration
      @@render_duration
    end

    def self.submit(entity)
      if @@submitted_entities[entity].nil?
        @@render_batch.submit(entity)
        @@submitted_entities[entity] = true
      end
    end

    def self.resize_window(new_width, new_height)
      @@width = new_width
      @@height = new_height
      @screen_size = Vec2.new(new_width, new_height)

      GL.viewport(0, 0, new_width, new_height)

      if perspective?
        perspective
      elsif orthogonal?
        orthogonal
      end
    end

    def self.projection
      @@projection
    end

    def self.screen_size
      @screen_size
    end

    def self.screen_width
      @@width
    end

    def self.screen_height
      @@height
    end

    def self.screen_to_world_ray(point)
      x = ((2.0 * point.x) / screen_width) - 1.0;
      y = 1.0 - (2.0 * point.y / screen_height);
      
      viewProjection = camera.view * projection
      viewProjectionInverse = viewProjection.invert
      
      near_pos = Vec4.new(x, y, 0, 1)
      transformed_near_pos = viewProjectionInverse.transform(near_pos)
      return nil if transformed_near_pos.w == 0
      transformed_near_pos /= transformed_near_pos.w

      far_pos = Vec4.new(x, y, 1, 1)
      transformed_far_pos = viewProjectionInverse.transform(far_pos)
      return nil if transformed_far_pos.w == 0
      transformed_far_pos /= transformed_far_pos.w

      near_3 = Vec3.new(transformed_near_pos.x, transformed_near_pos.y, transformed_near_pos.z)
      far_3 = Vec3.new(transformed_far_pos.x, transformed_far_pos.y, transformed_far_pos.z)

      origin = near_3
      direction = (far_3 - near_3).normalize

      QGame::Ray.new(origin, direction)
    end
  end
end
