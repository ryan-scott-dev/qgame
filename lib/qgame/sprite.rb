module QGame
  class Sprite
    @@model = nil
    @@shader = nil

    def initialize(args = {})
      @texture = args[:texture]
      @position = args[:position] || Vec2.new(1,1)
      @rotation = args[:rotation] || 0.0
      @scale = args[:scale] || Vec2.new(1)

      @timestep = 0
    end

    def self.model
      @@model ||= Game::AssetManager.model('triangle')
    end

    def self.shader
      @@shader ||= ShaderProgramAsset.new(Game::AssetManager.vertex('simple'), 
                                          Game::AssetManager.fragment('white'))
    end

    def update
      @timestep += 0.01
      @position.x = 3 + Math.sin(@timestep)
      @position.y = 2 + Math.cos(@timestep)

      QGame::RenderManager.submit(self)
    end

    def render
      Sprite.model.bind
      Sprite.shader.bind
      
      @texture.bind unless @texture.nil?
      Sprite.shader.set_uniform('tex', 0)
      Sprite.shader.set_uniform('projection', Mat4.orthogonal_2d(0, 8, 0, 6, -1, 1))

      Sprite.shader.set_uniform('position', @position)
      # Sprite.shader.set_uniform('rotation', @rotation)
      Sprite.shader.set_uniform('scale', @scale)

      Sprite.model.render
      
      @texture.unbind unless @texture.nil?
      Sprite.shader.unbind
      Sprite.model.unbind
    end
  end
end
