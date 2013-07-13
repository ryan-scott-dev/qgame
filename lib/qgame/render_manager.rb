module QGame
  class RenderManager
    @@render_queue = []
    @@camera = nil
    @@projection = nil
    @@width = 0
    @@height = 0

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
