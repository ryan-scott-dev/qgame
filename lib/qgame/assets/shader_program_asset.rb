module QGame
  class ShaderProgramAsset
    attr_accessor :vert, :frag, :program_id

    def initialize(vertex_shader, fragment_shader)
      @vert = vertex_shader
      @frag = fragment_shader
      @uniform_locations = {}

      link(vertex_shader, fragment_shader)
    end

    def uniform_location(name)      
      @uniform_locations[name] ||= self.find_uniform_location(name.to_s)
    end

    def set_uniform(name, value)
      location = uniform_location(name)

      if value.is_a? Fixnum
        set_uniform_fixnum(location, value)
      elsif value.is_a? Float
        set_uniform_float(location, value)
      elsif value.is_a? Vec2
        set_uniform_vec2(location, value)
      elsif value.is_a? Mat4
        set_uniform_mat4(location, value)
      elsif value.is_a? Vec4
        set_uniform_vec4(location, value)
      elsif value.is_a? Color
        set_uniform_vec4(location, value)
      end

    end
  end
end
