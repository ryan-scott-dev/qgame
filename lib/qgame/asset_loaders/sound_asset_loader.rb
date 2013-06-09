module QGame
  class SoundAssetLoader
    def load(asset_path)
      SoundAsset.from_file(asset_path)
    end
  end
end
