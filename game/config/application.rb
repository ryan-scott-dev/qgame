module Game
  class Application < QGame::Application
    def self.run(&block)
      Game::Application.new.run(&block)
    end
  end
end

# Game::Application.configure do
#   # Change the title of the window or the app
#   # conf.title = "Game is the coolest game ever"

#   # conf.version = "1.0.0"
# end
