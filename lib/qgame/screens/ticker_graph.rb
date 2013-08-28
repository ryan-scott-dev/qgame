module QGame
	class TickerGraph < Graph
		def initialize(args = {}, &block)
      @frequency = args[:frequency] || 1.0

      @timer = 0.0
      @calculate_text = block
      @start_time = Time.now.to_f

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
      add_value(Time.now.to_f - @start_time, self.instance_eval(&@calculate_text))
    end
	end
end
