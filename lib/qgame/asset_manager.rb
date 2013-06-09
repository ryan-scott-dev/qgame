module QGame
  module AssetManager
    @@asset_loaders = {}
    @@assets = []

    def self.load
      start = Time.now
      puts "Loading assets ..."

      Dir.entries('./assets').each do |file|
        next if file == '.' || file == '..'

        asset_type = file
        if Dir.exists?("./assets/#{asset_type}")
          Dir.entries("./assets/#{asset_type}").each do |asset|
            next if asset == '.' || asset == '..'

            load_asset(asset_type, "./assets/#{asset_type}/#{asset}")
          end
        else
          puts "Unknown asset: '#{file}'"
        end
      end
      elapsed = Time.now - start
      puts "Asset loading took #{elapsed.to_f} seconds"
    end

    def self.load_asset(asset_type, asset_path)
      loader = find_loader_for_asset_type(asset_type)
      if loader.nil?
        puts "Don't know how to process asset type '#{asset_type}'"  
      else
        loader.load(asset_path)
      end
    end

    def self.find_loader_for_asset_type(asset_type)
      return nil unless @@asset_loaders.has_key? asset_type

      @@asset_loaders[asset_type]
    end

    def self.register_asset_loader(asset_type, loader)
      @@asset_loaders[asset_type] = loader
    end

    def self.add_asset(asset_type, asset)
      @@assets[asset_type] = [] unless @@assets.has_key? asset_type
      @@assets[asset_type][asset.name] = {} unless @@assets[asset_type].has_key? asset.name
      @@assets[asset_type][asset.name] = asset
    end
  end
end
