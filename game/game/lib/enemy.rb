module TestGame
  class WorldObject; end

  class Enemy < WorldObject
    include QGame::EventHandler

    def initialize(args = {})
      @direction = Vec3.new(0, 0, 1)
      
      @health_indicator = WorldText.new(:text => "Hello World", :color => Color.red)
      @health_indicator_offset = Vec3.new(0, 5, 0)

      args[:scale] = Vec3.new(1, 2, 1)
      super(args)
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
