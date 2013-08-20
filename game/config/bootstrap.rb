module TestGame
  include Game

  class Application < QGame::Application
    def self.run(&block)
      Application.new.run(&block)
    end
  end
end
