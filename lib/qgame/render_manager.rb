module QGame
  class RenderManager
    @@render_queue = []
    @@camera = nil
    @@projection = nil

    def self.camera=(camera)
      @@camera = camera
    end

    def self.camera
      @@camera
    end

    def self.render
      @@render_queue.each do |model|
        model.render
      end

      @@render_queue.clear
    end

    def self.submit(model)
      @@render_queue << model
    end

    def self.resize_window(new_width, new_height)
      GL.viewport(0, 0, new_width, new_height)
      @@projection = Mat4.orthogonal_2d(0, new_width, 0, new_height)
    end

    def self.projection
      @@projection
    end

  end
end
