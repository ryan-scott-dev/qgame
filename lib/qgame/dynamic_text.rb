module QGame
  class DynamicText
    
    def initialize(args = {}, &block)
    end

    def destruct
      QGame::ScreenManager.current.remove(self)
    end

    def update
      QGame::RenderManager.submit(self)
    end

    def render
    end
  end
end
