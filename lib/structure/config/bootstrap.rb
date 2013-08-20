module $PROJ_NAME
  include Game

  class Application < Game::Application
    def self.run(&block)
      Game::Application.new.run(&block)
    end
  end
end
