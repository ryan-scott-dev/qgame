module QGame
  class ScenarioManager
    def self.define_scenario(scenario_name, &block)
      QGame::Scenario.new(scenario_name, &block)
    end
  end
end
