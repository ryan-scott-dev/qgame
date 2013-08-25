module QGame
	class TickerGraph

    attr_accessor :parent

		def initialize(args = {}, &block)
      @frequency = args[:frequency] || 1.0
      @timer = 0.0
      @calculate_text = block
      
      @values = []

      super(args)
    end

    def update
      @timer += Application.elapsed
      if @timer >= @frequency
        @timer = 0.0
        add_current_value
      end
    end

    def add_current_value
      add_value(self.instance_eval(&@calculate_text))
    end

    def add_value(value)
      puts value
      @values << value
    end

    def submit_render
    end

    def destruct
      self.parent.remove(self)
      self.parent = nil
    end
	end
end
