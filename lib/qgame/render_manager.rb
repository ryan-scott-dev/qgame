module QGame
  class RenderManager
    @@render_queue = []
    @@camera = nil
    @@projection = nil
    @@width = 0
    @@height = 0
    @@render_batch = {}

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

      @@render_batch.each do |model, entities|
        model.bind

        entities.each do |entity|
          entity.render
        end

        model.unbind
      end

      @@render_batch.clear

      @@render_queue.clear
    end

    def self.submit(entity)
      if !entity.respond_to?(:model) || entity.model.nil?
        @@render_queue << entity
      else
        @@render_batch[entity.model] = [] unless @@render_batch.has_key? entity.model
        @@render_batch[entity.model] << entity
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
