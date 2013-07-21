module Game
  class LevelGenerator

    def initialize
      @tile_width = @tile_height = 64
      @tile_offset = -tiles_per_screen
      @tile_position_offset = 0
      @tile_height_offset = 400

      @randomize = Random.new(1989)

      @texture = QGame::AssetManager.texture('grass_tiles')
      @tile_base_properties = {
        :texture => @texture,
        :sprite_relative_offset =>  Vec2.new(@tile_width) / @texture.size,
        :sprite_scale => Vec2.new(@tile_width) / @texture.size,
        :scale => Vec2.new(@tile_width)
      }

      @underground_tile_offset = Vec2.new(64, 128) / @texture.size

      @screen_offset = 0
      @screens = []

      @screens << build(tiles_per_screen)
      @screens << build(tiles_per_screen)
    end

    def tiles_per_screen
      (QGame::RenderManager.screen_width / @tile_width).ceil
    end

    def build(tile_count)
      screen = []
      (0..tile_count).each do |tile_index|
        @tile_position_offset = @tile_offset * @tile_width
        
        tile_rand = @randomize.rand
        if tile_rand < 0.2
          @tile_offset += 1

          next
        end

        if tile_rand > 0.8
          tile_properties = @tile_base_properties.merge({
            :position => Vec2.new(@tile_position_offset, @tile_height_offset - 2 * @tile_height), 
            :sprite_relative_offset =>  Vec2.new(5 * @tile_width, 0) / @texture.size,
          })
          tile = Game::Block.new(tile_properties)
          screen << tile
        end

        tile_properties = @tile_base_properties.merge({
          :position => Vec2.new(@tile_position_offset, @tile_height_offset), 
        })
        tile = Game::Block.new(tile_properties)
        screen << tile

        tile_properties = @tile_base_properties.merge({
          :position => Vec2.new(@tile_position_offset, @tile_height_offset + 64), 
          :sprite_relative_offset => @underground_tile_offset,
          :collidable => false
        })
        tile = Game::Block.new(tile_properties)
        screen << tile

        tile_properties = @tile_base_properties.merge({
          :position => Vec2.new(@tile_position_offset, @tile_height_offset + 128), 
          :sprite_relative_offset => @underground_tile_offset,
          :collidable => false
        })
        tile = Game::Block.new(tile_properties)
        screen << tile

        tile_properties = @tile_base_properties.merge({
          :position => Vec2.new(@tile_position_offset, @tile_height_offset + 192), 
          :sprite_relative_offset => @underground_tile_offset,
          :collidable => false
        })
        tile = Game::Block.new(tile_properties)
        screen << tile

        @tile_offset += 1
      end

      screen
    end

    def tiles_required?
      (QGame::RenderManager.camera.bounds.x + @tile_width) > (@tile_position_offset)
    end

    def cleanup_old_tiles
      @screens = @screens.slice(1, @screens.length - 1)
    end

    def update
      if tiles_required?
        @screens << build(tiles_per_screen)
        cleanup_old_tiles
      end

      @screens.each do |screen|
        screen.each do |tile|
          tile.update
        end
      end
    end
  end
end
