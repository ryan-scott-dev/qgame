module QGame
  class PropertyAnimation
    def initialize(host, property_name)
      @host = host
      @property_name = property_name
      @elapsed = 0
    end

    def from(val)
      @initial_value = val
      set_value(val)
      self
    end

    def to(val)
      @final_value = val
      self
    end

    def over(duration)
      @duration = duration
      self
    end

    def set_value(val)
      @host.send("#{@property_name}=", val)
    end

    def on_tick(&block)
      @on_tick = block
      self
    end

    def on_complete(&block)
      @on_complete = block
      self
    end
    
    def ease(current_time, initial_value, change_value, duration)
      return change_value * (current_time /= duration) * current_time + initial_value;
    end

    def update
      if !@finished || @elapsed < @duration
        @elapsed += Application.elapsed

        new_value = ease(@elapsed, @initial_value, @final_value - @initial_value, @duration)
        set_value(new_value)
        @on_tick.call(new_value) if @on_tick

        @finished = true if @elapsed >= @duration
      else
        @on_complete.call if @on_complete
      end
    end

  end
end
