module QGame
  class Scenario
    @@scenarios = {}

    def self.find(scenario_name)
      @@scenarios[scenario_name]
    end

    def self.has_scenario?(scenario_name)
      @@scenarios.has_key? scenario_name
    end

    attr_accessor :name
    
    def initialize(scenario_name, &block)
      @built = false
      @name = scenario_name
      @components = []
      
      @configure = block
      
      @@scenarios[scenario_name] = self
    end

    def reset
      build
    end

    def build
      destruct

      self.instance_eval(&@configure)
      @built = true
      self
    end

    def remove(entity)
      entity.parent = nil
      @components.delete(entity)
    end

    def add(entity)
      entity.parent = self
      @components << entity
    end
  end
end
