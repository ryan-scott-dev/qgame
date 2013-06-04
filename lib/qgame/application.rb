module QGame
  class Application
    def run(&block)
      SDL.init
      @window = Window.create("Test Window", 0, 0, 640, 480, [:shown, :opengl])
      
      block.call
    end
  end
end