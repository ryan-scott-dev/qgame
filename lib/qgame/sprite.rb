module QGame
  class Sprite
    @@model = nil
    @@shader = nil
    
    attr_accessor :position, :rotation, :scale, :offset, :texture, :transparency, :parent

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
      @z_index = args[:z_index] || 0.0
      @local_transparency = args[:transparency] || 1.0

      @alive = true

      calculate_transparency
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
      self.parent.remove(self)
      self.parent = nil
      @alive = false
    end

    def update
    end

    def calculate_transparency
      @absolute_transparency = @local_transparency
      @absolute_transparency *= @parent.transparency if @parent
    end

    def submit_render
      QGame::Application.render_manager.submit(self) if @alive
    end

    def top
      @position.y - (@offset.y * @scale.y)
    end

    def inside?(point)
      screen_space_point = point
      return false if screen_space_point.nil?

      world_position = @position - (@scale * @offset)
      screen_space_point.x > world_position.x && screen_space_point.x < world_position.x + @scale.x &&
      screen_space_point.y > world_position.y && screen_space_point.y < world_position.y + @scale.y
    end
    
    def render
      view = @screen_space ? Mat4.new : QGame::Application.render_manager.camera.view
      shader.set_uniform(:view, view)
      shader.set_uniform(:position, @position)
      shader.set_uniform(:rotation, @rotation)
      shader.set_uniform(:scale, @scale)
      shader.set_uniform(:offset, @offset)
      shader.set_uniform(:sprite_offset, @sprite_relative_offset)
      shader.set_uniform(:sprite_scale, @sprite_scale)
      shader.set_uniform(:z_index, @z_index)
      shader.set_uniform(:transparency, @absolute_transparency)

      model.render
    end
  end
end
