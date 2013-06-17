module Game
  include QGame

  class Application < QGame::Application
    def self.run(&block)
      Game::Application.new.run(&block)
    end
  end
end
