module QGame
  class Text
    @@shader = nil

    def self.shader
      @@shader ||= ShaderProgramAsset.new(QGame::AssetManager.vertex('screen_text'), 
                                          QGame::AssetManager.fragment('screen_text'))
    end
    
    attr_accessor :text, :size, :position

    def initialize(args = {})
      @position = args[:position] || Vec2.new
      @rotation = args[:rotation] || 0.0
      @offset = args[:offset] || Vec2.new(0.5)
      @font = args[:font] || './assets/fonts/Vera.ttf'
      @font_size = args[:font_size] || 16
      @text = args[:text] || ''
      @flag = args[:flag] || nil

      @text_buffer = FreetypeGL::FontBuffer.create(@font, @font_size)
      @text_buffer.set_text(@text, @flag)
      @size = @text_buffer.calculate_size(@text)
    end

    def text=(val)
      @text = val
      @text_buffer.set_text(@text, @flag)
    end

    def text
      @text
    end

    def destruct
      QGame::ScreenManager.current.remove(self)
    end

    def update
    end

    def submit_render
      QGame::RenderManager.submit(self)
    end

    def render
      shader = Text.shader
      @text_buffer.bind(shader.program_id)
      
      shader.set_uniform('texture', 0)
      shader.set_uniform('view', Mat4.new)
      shader.set_uniform('projection', QGame::RenderManager.projection)

      shader.set_uniform('position', @position)
      shader.set_uniform('rotation', @rotation)
      shader.set_uniform('offset', @offset)
      
      @text_buffer.render

      @text_buffer.unbind
    end
  end
end
