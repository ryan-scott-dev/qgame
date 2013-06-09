module QGame
  class ShaderAsset
    attr_accessor :name, :type

    def initialize(name, type)
      @name = name
      @type = ShaderAsset.type_to_sym(type)
    end

    def self.type_to_sym(type)
      case type
      when 'frag'
        return :fragment
      when 'vert'
        return :vertex
      end

      return :unknown
    end

    def self.from_file(file)
      name = shader_name_from_file(file)
      type = shader_type_from_file(file)

      shader = ShaderAsset.new(name, type)
      shader.load_from_file(shader.type, file)
      puts "Loaded #{file}"

      shader
    end

    def self.shader_name_from_file(file)
      file = file.gsub("\\","/")
      file.split('/').last.split('.').first
    end

    def self.shader_type_from_file(file)
      file.split('.').last
    end
  end
end
