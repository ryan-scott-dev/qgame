module QGame
  class Scenario
    @@scenarios = {}

    def self.find(scenario_name)
      @@scenarios[scenario_name]
    end

    def self.has_scenario?(scenario_name)
      @@scenarios.has_key? scenario_name
    end

    attr_accessor :name, :transparency, :parent
    
    def initialize(scenario_name, &block)
      @built = false
      @name = scenario_name
      @components = []
      @transparency = 1.0
      
      @configure = block
      
      @@scenarios[scenario_name] = self
    end

    def reset
      build
    end

    def build(parent)
      destruct

      self.instance_eval(&@configure)
      @built = true
      self
    end

    def destruct
      @components.each do |component|
        component.destruct
      end
    end

    def remove(entity)
      entity.parent = nil
      @components.delete(entity)
    end

    def add(entity)
      entity.parent = self
      @components << entity
    end


    def update
      @components.each do |component|
        component.update
      end
      
      @camera.update
    end

    def submit_render
      @components.each do |component|
        component.submit_render
      end
    end

    def calculate_transparency
      @components.each do |component|
        component.calculate_transparency
      end
    end

    def text(text, args = {}) 
      new_text = QGame::Text.new({:text => text}.merge(args))
      add(new_text)
      new_text
    end

    def camera(type, args = {})
      case type
      when :fixed  
        @camera = Application.render_manager.camera = QGame::Camera2D.new(args)
      when :follow
        @camera = Application.render_manager.camera = QGame::FollowCamera.new(args)
      end
    end
  end
end
