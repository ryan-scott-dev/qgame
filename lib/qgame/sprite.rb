module QGame
  class Sprite
    @@model = nil
    @@shader = nil

    def initialize(args = {})
      @texture = args[:texture]
      @position = args[:position] || Vec2.new(2)
      @rotation = args[:rotation] || 0.0
      @scale = args[:scale] || Vec2.new(1)
      @offset = args[:offset] || Vec2.new(0.5)
    end

    def self.model
      @@model ||= QGame::AssetManager.model('triangle')
    end

    def self.shader
      @@shader ||= ShaderProgramAsset.new(QGame::AssetManager.vertex('simple'), 
                                          QGame::AssetManager.fragment('white'))
    end

    def update
      QGame::RenderManager.submit(self)
    end

    def render
      Sprite.model.bind
      Sprite.shader.bind
      
      @texture.bind unless @texture.nil?
      Sprite.shader.set_uniform('tex', 0)
      Sprite.shader.set_uniform('projection', QGame::RenderManager.projection)
      Sprite.shader.set_uniform('view', QGame::RenderManager.camera.view)

      Sprite.shader.set_uniform('position', @position)
      Sprite.shader.set_uniform('rotation', @rotation)
      Sprite.shader.set_uniform('scale', @scale)
      Sprite.shader.set_uniform('offset', @offset)

      Sprite.model.render
      
      @texture.unbind unless @texture.nil?
      Sprite.shader.unbind
      Sprite.model.unbind
    end
  end
end
