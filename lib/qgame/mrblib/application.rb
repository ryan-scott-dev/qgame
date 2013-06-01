module QGame
  class Application
    def run(&block)
      SDL.init
      @window = SDL.set_video_mode(640, 480, 32, [:hw_surface, :double_buffer])

      block.call
    end
  end
end