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

	class Graph
    attr_accessor :parent

		def initialize(args = {}, &block)
      @color = args[:color] || :black
      @label = args[:label] || 'Un-named graph'
      @values_size = args[:values_size] || 600 # 60 seconds

      calculate_range

      super(args)
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
    end

    def render
      # Set shader variables: view, projection, color, step_size
    end

    def destruct
      self.parent.remove(self)
      self.parent = nil
    end
	end
end
