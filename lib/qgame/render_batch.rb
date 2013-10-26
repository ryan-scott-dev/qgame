module QGame
  class TextureRenderBatch
    def initialize
      @queue = []
      @batch = {}
    end

    def submit(entity)
      texture = entity.texture if entity.respond_to?(:texture)
      if texture.nil?
        @queue << entity
      else
        @batch[texture] ||= []
        @batch[texture] << entity
      end
    end

    def render
      @queue.each do |entity|
        entity.render
      end
      @queue.clear

      @batch.each do |texture, entities|
        texture.bind

        entities.each do |entity|
          entity.render
        end

        texture.unbind

        entities.clear
      end
    end
  end

  class ShaderRenderBatch
    def initialize
      @queue = []
      @batch = {}
    end

    def submit(entity)
      shader = entity.shader if entity.respond_to?(:shader)
      if shader.nil?
        @queue << entity
      else
        @batch[shader] ||= TextureRenderBatch.new
        @batch[shader].submit(entity)
      end
    end

    def render
      @queue.each do |entity|
        entity.render
      end
      @queue.clear

      @batch.each do |shader, entities|
        shader.bind
        shader.set_uniform(:projection, Application.render_manager.projection)
        shader.set_uniform(:tex, 0)

        entities.render

        shader.unbind
      end
    end
  end

  class ModelRenderBatch
    def initialize
      @queue = []
      @batch = {}
    end

    def submit(entity)
      model = entity.model if entity.respond_to?(:model)
      if model.nil?
        @queue << entity
      else
        @batch[model] ||= ShaderRenderBatch.new
        @batch[model].submit(entity)
      end
    end

    def render
      @batch.each do |model, entities|
        model.bind

        entities.render

        model.unbind
      end

      # Moved after to make sure text is always drawn last...
      @queue.each do |entity|
        entity.render
      end
      @queue.clear
    end
  end
end
