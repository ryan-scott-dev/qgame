class TextureRenderBatch
  def initialize
    @queue = []
    @batch = {}
  end

  def submit(entity)
    if !entity.respond_to?(:texture) || entity.texture.nil?
      @queue << entity
    else
      @batch[entity.texture] = [] unless @batch.has_key? entity.texture
      @batch[entity.texture] << entity
    end
  end

  def render
    @queue.each do |entity|
      entity.render
    end

    @batch.each do |texture, entities|
      texture.bind

      entities.each do |entity|
        entity.render
      end

      texture.unbind

      entities.clear
    end

    @queue.clear
  end
end

class ShaderRenderBatch
  def initialize
    @queue = []
    @batch = {}
  end

  def submit(entity)
    if !entity.respond_to?(:shader) || entity.shader.nil?
      @queue << entity
    else
      @batch[entity.shader] = TextureRenderBatch.new unless @batch.has_key? entity.shader
      @batch[entity.shader].submit(entity)
    end
  end

  def render
    @queue.each do |entity|
      entity.render
    end

    @batch.each do |shader, entities|
      shader.bind
      shader.set_uniform('projection', QGame::RenderManager.projection)
      shader.set_uniform('tex', 0)

      entities.render

      shader.unbind
    end

    @queue.clear
  end
end

class ModelRenderBatch
  def initialize
    @queue = []
    @batch = {}
  end

  def submit(entity)
    if !entity.respond_to?(:model) || entity.model.nil?
      @queue << entity
    else
      @batch[entity.model] = ShaderRenderBatch.new unless @batch.has_key? entity.model
      @batch[entity.model].submit(entity)
    end
  end

  def render
    @queue.each do |entity|
      entity.render
    end

    @batch.each do |model, entities|
      model.bind

      entities.render

      model.unbind
    end

    @queue.clear
  end
end
