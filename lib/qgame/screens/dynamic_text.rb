module QGame
  class Text
  end
  
  class DynamicText < Text
    
    def initialize(args = {}, &block)
      @frequency = args[:frequency] || 1.0
      @timer = 0.0
      @calculate_text = block

      super(args)
    end

    def update
      @timer += Application.elapsed
      if @timer >= @frequency
        @timer = 0.0
        update_text
      end
    end

    def update_text
      self.text = self.instance_eval(&@calculate_text).to_s
    end
  end
end
