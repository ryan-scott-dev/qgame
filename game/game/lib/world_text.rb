module TestGame
  class WorldText < WorldObject
    @@shader = nil

    def self.shader
      @@shader ||= QGame::ShaderProgramAsset.new(QGame::AssetManager.vertex('simple_textured_colored'), 
                                          QGame::AssetManager.fragment('simple_textured_colored'))
    end
    
    attr_accessor :text, :size, :parent

    def initialize(args = {})
      @font = args[:font] || './assets/fonts/Vera.ttf'
      @font_size = args[:font_size] || 16
      @text = args[:text] || ''
      @flag = args[:flag] || :normal
      @color = args[:color] || Color.black

      @position = args[:position] || Vec3.new
      @rotation = args[:rotation] || Vec3.new
      @scale = args[:scale] || Vec3.new(0.05, -0.05, 0.05)
      @world_mat = Mat4.new

      @text_buffer = FreetypeGL::FontBuffer.create(@font, @font_size)
      self.text = @text

      @alive = true
    end

    def text=(val)
      @text = val
      @text_buffer.set_text(@text, @flag)
      @size = @text_buffer.calculate_size(@text)
    end

    def text
      @text
    end

    def position=(val)
      @position = val - Vec3.new((@size.x * @scale.x) / 2, (@size.y * @scale.y) / 2, 0)
    end

    def destruct
      @parent.remove(self) if @parent
      @parent = nil
      @alive = false
    end

    def face_rotation(target_position, up)
      look = (target_position - @position).normalize
      right = Vec3.cross(up, look)
      up2 = Vec3.cross(look, right);

      face_mat = Mat4.new
      face_mat.f11 = right.x
      face_mat.f12 = right.y
      face_mat.f13 = right.z

      face_mat.f21 = up2.x
      face_mat.f22 = up2.y
      face_mat.f23 = up2.z

      face_mat.f31 = look.x
      face_mat.f32 = look.y
      face_mat.f33 = look.z      

      face_mat.to_rotation * Vec3.new(-1, 1, -1)
    end

    def update
      camera = QGame::Application.render_manager.camera
      @rotation = face_rotation(camera.position, camera.up)
      @world_mat = @world_mat.calculate_transform(@position, @rotation, @scale)
    end

    def submit_render
      Application.render_manager.submit(self) if @alive
    end

    def render
      shader = WorldText.shader
      @text_buffer.bind(shader.program_id)
      GL.blend_alpha_transparency

      shader.set_uniform(:texture, 0)
      view = QGame::Application.render_manager.camera.view
      shader.set_uniform(:projection, Application.render_manager.projection)
      shader.set_uniform(:view, view)
      shader.set_uniform(:world, @world_mat)
      shader.set_uniform(:tint, @color)
       
      @text_buffer.render

      GL.blend_alpha_transparency
      @text_buffer.unbind
    end
  end
end
