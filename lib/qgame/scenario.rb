module QGame
  class Scenario
    @@scenarios = {}

    def self.find(scenario_name)
      @@scenarios[scenario_name]
    end

    def self.has_scenario?(scenario_name)
      @@scenarios.has_key? scenario_name
    end

    include QGame::Buildable
    include QGame::BuildableHelpers
    include QGame::Composite

    attr_accessor :name, :transparency, :parent
    
    def initialize(scenario_name, &block)
      @built = false
      @name = scenario_name
      @components = []
      @transparency = 1.0
      
      @configure = block
      
      @@scenarios[scenario_name] = self
    end

    def destruct
      destruct_children
    end

    def update
      update_children
      @camera.update unless @camera.nil?
    end

    def submit_render
      submit_render_children
    end
    
    def calculate_transparency
      @components.each do |component|
        component.calculate_transparency
      end
    end

    def terminate_after(duration)
      
    end
  end
end
