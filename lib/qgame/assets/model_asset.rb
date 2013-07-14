module QGame
  class ModelAsset
    attr_accessor :name

    def type
      :model
    end

    def self.from_file(file)
      name = asset_name_from_file(file)
      
      model = ModelAsset.new
      model.name = name
      model.load_from_file(file)
      puts "Loaded #{file}"

      model
    end

    def self.asset_name_from_file(file)
      file = file.gsub("\\","/")
      file.split('/').last.split('.').first
    end
  end
end
