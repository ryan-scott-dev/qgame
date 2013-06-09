module QGame
  class ShaderAssetLoader
    def load(asset_path)
      ShaderAsset.from_file(asset_path)
    end
  end
end
