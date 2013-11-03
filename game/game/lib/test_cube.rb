module TestGame
  class TestCube
    @@model = nil
    @@shader = nil
    
    attr_accessor :position, :rotation, :scale, :texture, :parent
    alias_method :size, :scale

    def initialize(args = {})
      @texture = args[:texture]
      @position = args[:position] || Vec3.new
      @rotation = args[:rotation] || Vec3.new
      @scale = args[:scale] || Vec3.new(1)

      @alive = true
    end

    def self.model
      @@model ||= QGame::AssetManager.model('cube')
    end

    def model
      TestCube.model
    end

    def self.shader
      @@shader ||= QGame::ShaderProgramAsset.new(QGame::AssetManager.vertex('simple'), 
                                          QGame::AssetManager.fragment('simple'))
    end

    def shader
      TestCube.shader
    end

    def destruct
      @parent.remove(self) if @parent
      @parent = nil
      @alive = false
    end

    def update
      @rotation.x += Application.elapsed
      @rotation.y += Application.elapsed
      @rotation.z += Application.elapsed
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
