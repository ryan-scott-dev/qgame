module QGame
  class Sprite
    @@model = nil
    @@shader = nil
    
    attr_accessor :position, :rotation, :scale, :offset

    def initialize(args = {})
      @texture = args[:texture]
      @position = args[:position] || Vec2.new
      @rotation = args[:rotation] || 0.0
      @scale = args[:scale] || @texture.size
      @offset = args[:offset] || Vec2.new(0.5)
      @screen_space = args[:screen_space] || false
    end

    def self.model
      @@model ||= QGame::AssetManager.model('triangle')
    end

    def self.shader
      @@shader ||= ShaderProgramAsset.new(QGame::AssetManager.vertex('sprite'), 
                                          QGame::AssetManager.fragment('sprite'))
    end

    def destruct
      QGame::ScreenManager.current.remove(self)
    end

    def update
      QGame::RenderManager.submit(self)
    end

    def render
      model = Sprite.model
      shader = Sprite.shader

      model.bind
      shader.bind
      
      @texture.bind unless @texture.nil?
      shader.set_uniform('tex', 0)
      shader.set_uniform('projection', QGame::RenderManager.projection)

      view = @screen_space ? Mat4.new : QGame::RenderManager.camera.view
      shader.set_uniform('view', view)

      shader.set_uniform('position', @position)
      shader.set_uniform('rotation', @rotation)
      shader.set_uniform('scale', @scale)
      shader.set_uniform('offset', @offset)
      
      GL.blend_alpha_transparency
      
      model.render
      
      GL.blend_opaque

      @texture.unbind unless @texture.nil?
      shader.unbind
      model.unbind
    end
  end
end
