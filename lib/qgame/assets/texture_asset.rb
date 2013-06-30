module QGame
  class TextureAsset
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def type
      :texture
    end

    def size
      @size ||= Vec2.new(@width, @height)
    end

    def self.from_file(file)
      name = asset_name_from_file(file)
      
      texture = TextureAsset.new(name)
      texture.load_from_file(file)
      puts "Loaded #{file}"

      texture
    end

    def self.asset_name_from_file(file)
      file = file.gsub("\\","/")
      file.split('/').last.split('.').first
    end
  end
end
