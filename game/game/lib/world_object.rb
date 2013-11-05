module TestGame
  class WorldObject
    attr_accessor :position, :rotation, :scale, :parent, :model, :shader
    alias_method :size, :scale

    def initialize(args = {})
      @texture = args[:texture]
      @position = args[:position] || Vec3.new
      @rotation = args[:rotation] || Vec3.new
      @scale = args[:scale] || Vec3.new(1)
      @model = QGame::AssetManager.model(args[:model] || 'cube')

      vertex_name = args[:vertex_shader] || args[:shader] || 'simple'
      fragment_name = args[:fragment_shader] || args[:shader] || 'simple'
      @shader = QGame::ShaderProgramAsset.new(QGame::AssetManager.vertex(vertex_name), 
                                          QGame::AssetManager.fragment(fragment_name))
      
      @alive = true
    end

    def destruct
      @parent.remove(self) if @parent
      @parent = nil
      @alive = false
    end

    def update
    end

    def calculate_transparency
    end

    def submit_render
      QGame::Application.render_manager.submit(self) if @alive
    end
    
    def render
      view = QGame::Application.render_manager.camera.view
      shader.set_uniform(:view, view)
      shader.set_uniform(:position, @position)
      shader.set_uniform(:scale, @scale)
      shader.set_uniform(:rotation, @rotation)
      
      model.render
    end
  end
end