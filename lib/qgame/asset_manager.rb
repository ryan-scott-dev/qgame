module QGame
  module AssetManager
    @@asset_loaders = {}
    @@assets = {}
    @@blacklist = ['.', '..']
    @@blacklist_partial = ['.DS_Store', '.keep', '.gitkeep']

    def self.blacklist
      @@blacklist
    end

    def self.blacklist_partial
      @@blacklist_partial
    end

    def self.load
      start = Time.now
      puts "Loading assets ..."

      Dir.entries('./assets').each do |file|
        next if blacklist.include?(file)
        next if blacklist_partial.any? {|partial| file.include?(partial)}

        asset_type = file
        if Dir.exists?("./assets/#{asset_type}")
          Dir.entries("./assets/#{asset_type}").each do |asset|
            next if blacklist.include?(asset)
            next if blacklist_partial.any? {|partial| asset.include?(partial)}

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
        asset = loader.load(asset_path)
        add_asset(asset)
      end
    end

    def self.find_loader_for_asset_type(asset_type)
      return nil unless @@asset_loaders.has_key? asset_type

      @@asset_loaders[asset_type]
    end

    def self.register_asset_loader(asset_type, loader)
      @@asset_loaders[asset_type] = loader
    end

    def self.assets
      @@assets
    end

    def self.add_asset(asset)
      unless assets.has_key? asset.type
        assets[asset.type] = {} 
        singleton_class.define_method asset.type do |name|
          assets[asset.type][name]
        end
      end

      assets[asset.type][asset.name] = {} unless assets[asset.type].has_key? asset.name
      assets[asset.type][asset.name] = asset
    end
  end
end
