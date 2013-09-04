module QGame
  class Text
    @@shader = nil

    def self.shader
      @@shader ||= ShaderProgramAsset.new(QGame::AssetManager.vertex('screen_text'), 
                                          QGame::AssetManager.fragment('screen_text'))
    end
    
    attr_accessor :text, :size, :position, :parent

    def initialize(args = {})
      @position = args[:position] || Vec2.new
      @rotation = args[:rotation] || 0.0
      @offset = args[:offset] || Vec2.new(0.5)
      @font = args[:font] || './assets/fonts/Vera.ttf'
      @font_size = args[:font_size] || 16
      @text = args[:text] || ''
      @flag = args[:flag] || :normal
      @z_index = args[:z_index] || 0.0
      @local_transparency = args[:transparency] || 1.0

      @text_buffer = FreetypeGL::FontBuffer.create(@font, @font_size)
      self.text = @text
      calculate_transparency
    end

    def text=(val)
      @text = val
      @text_buffer.set_text(@text, @flag)
      @size = @text_buffer.calculate_size(@text)
    end

    def text
      @text
    end

    def destruct
      self.parent.remove(self)
      self.parent = nil
    end

    def calculate_transparency
      @absolute_transparency = @local_transparency
      @absolute_transparency *= @parent.transparency if @parent
    end

    def update
    end

    def submit_render
      Application.render_manager.submit(self)
    end

    def shader_offset
      @offset * @size # Creating two instances of TT_DATA
    end

    def render
      shader = Text.shader
      @text_buffer.bind(shader.program_id)
      
      shader.set_uniform(:texture, 0)
      shader.set_uniform(:view, Mat4.identity)
      shader.set_uniform(:projection, Application.render_manager.projection)
      shader.set_uniform(:position, @position)
      shader.set_uniform(:rotation, @rotation)
      shader.set_uniform(:offset, shader_offset)
      shader.set_uniform(:z_index, @z_index)
      shader.set_uniform(:transparency, @absolute_transparency)

      @text_buffer.render

      @text_buffer.unbind
    end
  end
end
