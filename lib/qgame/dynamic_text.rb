module QGame
  class DynamicText
    
    def initialize(args = {}, &block)
      @frequency = args[:frequency] || 1.0
      @text_buffer = FreetypeGL::FontBuffer.create('./assets/fonts/Vera.ttf', 16)

      @timer = 0.0
      @calculate_text = block
    end

    def destruct
      QGame::ScreenManager.current.remove(self)
    end

    def update
      @timer += Application.elapsed
      if @timer >= @frequency
        @timer = 0
        @text = self.instance_eval(&@calculate_text).to_s
        @text_buffer.text = @text
      end
      QGame::RenderManager.submit(self)
    end

    def render
    end
  end
end
