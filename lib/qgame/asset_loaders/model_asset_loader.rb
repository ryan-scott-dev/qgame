module QGame
  class ModelAssetLoader
    def load(asset_path)
      ModelAsset.from_file(asset_path)
    end
  end
end
