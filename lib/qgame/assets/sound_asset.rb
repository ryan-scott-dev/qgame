module QGame
  class SoundAsset
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def type
      :sound
    end

    def self.from_file(file)
      name = asset_name_from_file(file)
      
      sound = SoundAsset.new(name)
      sound.load_from_file(file)
      puts "Loaded #{file}"

      sound
    end

    def self.asset_name_from_file(file)
      file = file.gsub("\\","/")
      file.split('/').last.split('.').first
    end
  end
end
