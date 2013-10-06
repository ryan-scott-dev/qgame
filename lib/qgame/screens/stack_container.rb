module QGame
  class StackContainer

    include QGame::Buildable
    include QGame::BuildableHelpers
    include QGame::Composite

    attr_accessor :transparency, :parent

    def initialize(args, &block)
      @components = []
      
      @configure = block
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
