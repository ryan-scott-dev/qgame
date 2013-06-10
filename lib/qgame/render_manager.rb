module QGame
  class RenderManager
    @@render_queue = []

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
