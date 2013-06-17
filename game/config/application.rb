module Game
  include QGame

  class Application < QGame::Application
    def self.run(&block)
      Game::Application.new.run(&block)
    end

    conf[:title] = "Game is the coolest game ever"
    conf[:window_flags] = [:shown, :resizable, :opengl]
    conf[:start_size] = [800, 600]
  end
end