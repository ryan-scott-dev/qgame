module QGame
  class Sprite
    @@model = nil
    @@shader = nil

    def initialize(args = {})
      @texture = args[:texture]
    end

    def self.model
      @@model ||= Game::AssetManager.model('triangle')
    end

    def self.shader
      @@shader ||= ShaderProgramAsset.new(Game::AssetManager.vertex('simple'), 
                                          Game::AssetManager.fragment('white'))
    end

    def update
      QGame::RenderManager.submit(self)
    end

    def render
      Sprite.model.bind
      Sprite.shader.bind
      
      @texture.bind unless @texture.nil?
      Sprite.shader.set_uniform('tex', 0)

      Sprite.model.render
      
      @texture.unbind unless @texture.nil?
      Sprite.shader.unbind
      Sprite.model.unbind
    end
  end
end
