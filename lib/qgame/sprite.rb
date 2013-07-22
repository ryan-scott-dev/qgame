module QGame
  class Sprite
    @@model = nil
    @@shader = nil
    
    attr_accessor :position, :rotation, :scale, :offset, :texture

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
      @sprite_scale = args[:sprite_scale] || @sprite_size / @texture.size

      @alive = true
    end

    def self.model
      @@model ||= QGame::AssetManager.model('triangle')
    end

    def model
      Sprite.model
    end

    def self.shader
      @@shader ||= ShaderProgramAsset.new(QGame::AssetManager.vertex('sprite'), 
                                          QGame::AssetManager.fragment('sprite'))
    end

    def shader
      Sprite.shader
    end

    def destruct
      QGame::ScreenManager.current.remove(self)
      @alive = false
    end

    def update
      QGame::RenderManager.submit(self) if @alive
    end

    def render
      view = @screen_space ? Mat4.new : QGame::RenderManager.camera.view
      shader.set_uniform('view', view)

      shader.set_uniform('position', @position)
      shader.set_uniform('rotation', @rotation)
      shader.set_uniform('scale', @scale)
      shader.set_uniform('offset', @offset)
      shader.set_uniform('sprite_offset', @sprite_relative_offset)
      shader.set_uniform('sprite_scale', @sprite_scale)
      
      model.render
    end
  end
end
