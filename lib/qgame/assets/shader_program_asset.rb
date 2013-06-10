module QGame
  class ShaderProgramAsset
    attr_accessor :vert, :frag

    def initialize(vertex_shader, fragment_shader)
      @vert = vertex_shader
      @frag = fragment_shader

      link(vertex_shader, fragment_shader)
    end
  end
end
