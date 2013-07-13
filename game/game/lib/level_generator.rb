module Game
  class LevelGenerator

    def initialize
      @tile_width = 64
      @tiles_per_screen = (QGame::RenderManager.screen_width / @tile_width).ceil
      @tile_offset = 0
      @tile_position_offset = 0
      @tile_height_offset = 400
      @tile_start_offset = 0

      @tiles = []
      build(@tiles_per_screen)
    end

    def build(tile_count)
      (0..tile_count).each do |tile_index|
        @tile_position_offset = @tile_offset * @tile_width
        
        tile_properties = {
          :position => Vec2.new(@tile_position_offset, @tile_height_offset), 
          :texture => QGame::AssetManager.texture('wood'),
          :scale => Vec2.new(@tile_width, @tile_width)
        }

        tile = QGame::Sprite.new(tile_properties)
        @tiles << tile

        @tile_offset += 1
      end

      puts "Built #{tile_count} tiles"
    end

    def tiles_required?
      (QGame::RenderManager.camera.bounds.x + @tile_width) > (@tile_position_offset)
    end

    def tiles_out_of_bounds
      ((@tile_start_offset - QGame::RenderManager.camera.position.x) / @tile_width).ceil
    end

    def cleanup_old_tiles
      tile_count = tiles_out_of_bounds
      @tiles = @tiles.slice(tile_count, @tiles.length - tile_count)
      @tile_start_offset = @tile_position_offset
    end

    def update
      if tiles_required?
        build(@tiles_per_screen)
        cleanup_old_tiles
      end

      @tiles.each do |tile|
        tile.update
      end
    end
  end
end
