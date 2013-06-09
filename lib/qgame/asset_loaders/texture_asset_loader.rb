module QGame
  class TextureAssetLoader
    def load(asset_path)
      TextureAsset.from_file(asset_path)
    end
  end
end
