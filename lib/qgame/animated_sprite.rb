module QGame
  class Sprite
  end

  class AnimatedSprite < Sprite
    @@shader = nil

    def initialize(args = {})
      super(args)

      @frame_size = args[:frame_size] || Vec2.new
      @scale = args[:frame_size] || args[:scale] || @texture.size

      @frames = []
      @current_frame = 0
      @animating = args[:started]
      @animating = true unless args.has_key? :started
      
      @frame_rate = args[:frame_rate]

      calculate_frame_positions
    end
    
    def calculate_frame_positions
      frames_horizontally = (@texture.width / @frame_size.x).to_i
      frames_vertically = (@texture.height / @frame_size.y).to_i
      
      @frames = []

      (0...frames_vertically).each do |offset_y|
        (0...frames_horizontally).each do |offset_x|
          @frames << Vec2.new(offset_x * @frame_size.x / @texture.width, offset_y * @frame_size.y / @texture.height)
        end
      end
    end

    def self.shader
      @@shader ||= ShaderProgramAsset.new(QGame::AssetManager.vertex('animated_sprite'), 
                                          QGame::AssetManager.fragment('sprite'))
    end

    def frame_offset
      @frame_size / @texture.size
    end

    def start
      @animating = true
    end

    def stop
      @animating = false
    end

    def update
      if @animating
        @current_frame += @frame_rate
        @current_frame = 0 if @current_frame >= @frames.length
      end

      super
    end

    def render
      model = Sprite.model
      shader = AnimatedSprite.shader

      model.bind
      shader.bind
      
      @texture.bind unless @texture.nil?
      shader.set_uniform('tex', 0)
      shader.set_uniform('projection', QGame::RenderManager.projection)
      shader.set_uniform('view', QGame::RenderManager.camera.view)

      shader.set_uniform('position', @position)
      shader.set_uniform('rotation', @rotation)
      shader.set_uniform('scale', @scale)
      shader.set_uniform('offset', @offset)
      shader.set_uniform('frame_offset', @frames[@current_frame.to_i])
      shader.set_uniform('frame_scale', frame_offset)
      
      GL.blend_alpha_transparency
      
      model.render
      
      GL.blend_opaque

      @texture.unbind unless @texture.nil?
      shader.unbind
      model.unbind
    end
  end
end
