module QGame
  # <= y_max             X                 X     X     
  #                X     .                 .     .     X
  #          X     .     .     X     x     .     .     .
  # x_max <= |-----|-----|-----|-----|-----|-----|-----| => x_min
  # <= y_min    |
  #             |
  #              => interval
  
  # Values after x_max are not displayed
  # Values are clamped between y_max and y_min

  class Graph < GraphObject

    @@shader = nil

    def self.shader
      @@shader ||= ShaderProgramAsset.new(QGame::AssetManager.vertex('graph'), 
                                          QGame::AssetManager.fragment('graph'))
    end
	
    attr_accessor :parent

		def initialize(args = {}, &block)
      @color = args[:color] || :black
      @label = args[:label] || 'Un-named graph'
      @values_size = args[:values_size] || 600 # 60 seconds

      super
    end

    def update
    end

    def add_value(x_value, y_value)
      push_value(x_value, y_value)

      @y_max = y_value if @y_max.nil? || y_value > @y_max 
      @y_min = y_value if @y_min.nil? || y_value < @y_min

      @x_max = x_value if @x_max.nil? || x_value > @x_max 
      @x_min = x_value if @x_min.nil? || x_value < @x_min
    end

    def submit_render
      Application.render_manager.submit(self)
    end

    def render
      shader = Graph.shader
      self.bind(shader.program_id)
      
      shader.set_uniform('view', Mat4.new)
      shader.set_uniform('projection', Application.render_manager.projection)

      super

      self.unbind
    end

    def destruct
      self.parent.remove(self)
      self.parent = nil
    end
	end
end
