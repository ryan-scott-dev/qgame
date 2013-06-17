module QGame
  class RenderManager
    @@render_queue = []
    @@camera = nil

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
  end
end
