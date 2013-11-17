module TestGame
  class WorldObject; end

  class Enemy < WorldObject
    include QGame::EventHandler

    attr_accessor :health

    def initialize(args = {})
      @direction = Vec3.new(0, 0, 1)
      
      @health = args[:health] || 10
      @health_indicator = WorldText.new(:text => @health.to_s, :color => Color.red)
      @health_indicator_offset = Vec3.new(0, 5, 0)
      
      args[:scale] = Vec3.new(1, 2, 1)
      super(args)
    end

    def health=(val)
      @health = val
      @health_indicator.text = @health.to_s
    end

    def update
      if @health_indicator
        @health_indicator.update 
        @health_indicator.position = @position + @health_indicator_offset
      end
      super
    end

    def submit_render
      @health_indicator.submit_render if @health_indicator
      super
    end

  end
end
