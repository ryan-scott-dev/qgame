module QGame
  class Screen
  end

  class ScenarioScreen < Screen
    def self.enable(scenario)
      ScenarioScreen.new(:scenario_screen) do
        load_scenario(scenario)

        overlay(:analyse) if QGame::Screen.has_screen?(:analyse)
      end
    end

    def load_scenario(scenario)
      scenario.build
      add(scenario)
    end
  end
end
