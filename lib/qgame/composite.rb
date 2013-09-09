module QGame
  module Composite
    attr_accessor :components

    def remove(entity)
      entity.parent = nil
      @components.delete(entity)
    end

    def add(entity)
      entity.parent = self
      @components << entity
    end

    def destruct_children
      @components.each do |component|
        component.destruct
      end   
    end

    def update_children
      @components.each do |component|
        component.update
      end
    end

    def submit_render_children
      @components.each do |component|
        component.submit_render
      end
    end

  end
end
