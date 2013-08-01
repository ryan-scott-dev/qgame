module QGame
  class DynamicText
    @@shader = nil

    def self.shader
      @@shader ||= ShaderProgramAsset.new(QGame::AssetManager.vertex('screen_text'), 
                                          QGame::AssetManager.fragment('screen_text'))
    end
    
    attr_accessor :parent

    def initialize(args = {}, &block)
      @frequency = args[:frequency] || 1.0
      @position = args[:position] || Vec2.new
      @rotation = args[:rotation] || 0.0
      @offset = args[:offset] || Vec2.new(0.5)
      @font = args[:font] || './assets/fonts/Vera.ttf'
      @font_size = args[:font_size] || 16
      @z_index = args[:z_index] || 0.0
      @local_transparency = args[:transparency] || 1.0
      
      @text_buffer = FreetypeGL::FontBuffer.create(@font, @font_size)

      @timer = 0.0
      @calculate_text = block
      calculate_transparency
    end

    def destruct
      QGame::ScreenManager.current.remove(self)
    end

    def update
      @timer += Application.elapsed
      if @timer >= @frequency
        @timer = 0.0
        update_text
      end
    end

    def submit_render
      QGame::RenderManager.submit(self)
    end

    def update_text
      @text = self.instance_eval(&@calculate_text).to_s
      @text_buffer.set_text(@text)
    end
    
    def calculate_transparency
      @absolute_transparency = @local_transparency
      @absolute_transparency *= @parent.transparency if @parent
    end

    def render
      shader = DynamicText.shader
      @text_buffer.bind(shader.program_id)
      
      shader.set_uniform('texture', 0)
      shader.set_uniform('view', Mat4.new)
      shader.set_uniform('projection', QGame::RenderManager.projection)

      shader.set_uniform('position', @position)
      shader.set_uniform('rotation', @rotation)
      shader.set_uniform('offset', @offset)
      shader.set_uniform('z_index', @z_index)
      shader.set_uniform('transparency', @absolute_transparency)
      
      @text_buffer.render

      @text_buffer.unbind
    end
  end
end
