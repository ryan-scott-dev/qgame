module QGame
  class RenderManager
    @@camera = nil
    @@projection = nil
    @@width = 0
    @@height = 0

    @@render_batch = ModelRenderBatch.new
    @@submitted_entities = {}

    def self.camera=(camera)
      @@camera = camera
    end

    def self.camera
      @@camera
    end

    def self.render
      GL.blend_alpha_transparency
      
      @@render_batch.render
      @@submitted_entities.clear
      
      GL.blend_opaque
    end

    def self.submit(entity)
      # This is currently rendering multiple times per frame...
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
      @@projection = Mat4.orthogonal_2d(0, new_width, 0, new_height)
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

  end
end
