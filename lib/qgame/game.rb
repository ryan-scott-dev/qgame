module QGame
	class InputMapping
	end

	class Application
	end
end

module Game
	class InputMapping < QGame::InputMapping
	end

	class Application < QGame::Application
    def self.run(&block)
      Application.new.run(&block)
    end
  end
end
