module QGame
  class ShaderProgramAsset
    attr_accessor :vert, :frag, :program_id

    def initialize(vertex_shader, fragment_shader)
      @vert = vertex_shader
      @frag = fragment_shader

      link(vertex_shader, fragment_shader)
    end

    def set_uniform(name, value)
      if value.is_a? Fixnum
        set_uniform_fixnum(name, value)
      elsif value.is_a? Float
        set_uniform_float(name, value)
      elsif value.is_a? Vec2
        set_uniform_vec2(name, value)
      elsif value.is_a? Mat4
        set_uniform_mat4(name, value)
      elsif value.is_a? Vec4
        set_uniform_vec4(name, value)
      end

    end
  end
end
