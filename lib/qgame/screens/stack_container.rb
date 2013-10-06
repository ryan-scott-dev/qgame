module QGame
  class StackContainer

    include QGame::EventManager
    include QGame::Buildable
    include QGame::BuildableHelpers
    include QGame::Composite

    attr_accessor :transparency, :parent, :position, :direction, :size

    def initialize(args, &block)
      @components = []
      @direction = args[:direction] || :vertical
      @size = Vec2.new
      @position = Vec2.new

      @configure = block
    end

    def position=(new_position)
      offset = new_position - @position

      @components.each do |component|
        component.position += offset

        puts component.position
      end
      @position = new_position
    end

    def build
      super

      # Rearrange children based on container type
      @components.each do |component|
        @size.x = component.size.x if component.size.y > size.x
        @size.y += component.size.y

        component.position += @position
      end

      puts @size
    end

    def destruct
      destruct_children
    end

    def update
      update_children
    end

    def submit_render
      submit_render_children
    end
    
    def calculate_transparency
      @components.each do |component|
        component.calculate_transparency
      end
    end
  end
end
