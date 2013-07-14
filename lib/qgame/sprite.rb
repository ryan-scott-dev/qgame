module QGame
  class Sprite
    @@model = nil
    @@shader = nil
    
    attr_accessor :position, :rotation, :scale, :offset

    def initialize(args = {})
      @texture = args[:texture]
      @position = args[:position] || Vec2.new
      @rotation = args[:rotation] || 0.0
      @offset = args[:offset] || Vec2.new(0.5)
      @screen_space = args[:screen_space] || false

      @sprite_offset = args[:sprite_offset] || Vec2.new
      @sprite_relative_offset = args[:sprite_relative_offset] || @sprite_offset / @texture.size
      @sprite_size = args[:sprite_size] || @texture.size
      @scale = args[:scale] || @sprite_size
      @sprite_scale = args[:frame_scale] || @sprite_size / @texture.size
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
      shader.set_uniform('sprite_offset', @sprite_relative_offset)
      shader.set_uniform('sprite_scale', @sprite_scale)
      
      GL.blend_alpha_transparency
      
      model.render
      
      GL.blend_opaque

      @texture.unbind unless @texture.nil?
      shader.unbind
      model.unbind
    end
  end
end
