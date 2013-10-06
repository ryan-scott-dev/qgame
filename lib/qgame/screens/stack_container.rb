module QGame
  class StackContainer

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
      end
      @position = new_position
    end

    def on_event(event, &block)
      parent.on_event(event, &block)
    end

    def build
      super

      # Rearrange children based on container type
      offset = Vec2.new
      @components.each do |component|
        component.position.y += @position.y + @size.y

        @size.x = component.size.x if component.size.y > size.x
        @size.y += component.size.y
      end
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
