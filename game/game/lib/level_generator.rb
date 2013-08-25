module TestGame
  class LevelGenerator
    attr_accessor :parent

    def initialize(player)
      @player = player

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
      
      @gap_count = 0
      @last_gap_offset = 0
      @min_gap_offset = 4

      @difficulty = 0
      @screens = []

      @screens << build(tiles_per_screen)
      @screens << build(tiles_per_screen)

      @difficulty = 1
    end

    def calculate_transparency
      @absolute_transparency = 1
      @absolute_transparency *= @parent.transparency if @parent

      @screens.each do |screen|
        screen.each do |tile|
          tile.calculate_transparency
        end
      end
    end

    def transparency
      @absolute_transparency
    end

    def safe_gap_width
      4  
    end

    def tiles_per_screen
      (Application.render_manager.screen_width / @tile_width).ceil
    end

    def build(tile_count)
      screen = []
      (0..tile_count).each do |tile_index|
        @tile_position_offset = @tile_offset * @tile_width
        
        tile_properties = @tile_base_properties.merge({
          :position => Vec2.new(@tile_position_offset, @tile_height_offset + 4 * @tile_height)
        })
        tile = TestGame::Block.new(tile_properties)
        tile.parent = self
        screen << tile
        
        tile_rand = @randomize.rand
        if tile_rand < 0.05 && @difficulty > 0 && @last_gap_offset > @min_gap_offset
          @gap_count = safe_gap_width
        end

        if @gap_count > 0
          @tile_offset += 1
          @gap_count -= 1
          @last_gap_offset = 0
          next
        end
        @last_gap_offset += 1

        if tile_rand > 0.6 && tile_rand < 0.65
          coin = TestGame::Coin.new(:position => Vec2.new(@tile_position_offset, @tile_height_offset - @tile_height), :parent => screen)
          coin.parent = self
          screen << coin
        end

        if tile_rand > 0.8 && tile_rand < 0.9
          tile_properties = @tile_base_properties.merge({
            :position => Vec2.new(@tile_position_offset, @tile_height_offset - 2 * @tile_height), 
            :sprite_relative_offset =>  Vec2.new(5 * @tile_width, 0) / @texture.size,
          })
          tile = TestGame::Block.new(tile_properties)
          tile.parent = self
          screen << tile
        elsif tile_rand > 0.9
          tile_properties = @tile_base_properties.merge({
            :position => Vec2.new(@tile_position_offset, @tile_height_offset - 3 * @tile_height), 
            :sprite_relative_offset =>  Vec2.new(5 * @tile_width, 0) / @texture.size,
          })
          tile = TestGame::Block.new(tile_properties)
          tile.parent = self
          screen << tile
        end

        tile_properties = @tile_base_properties.merge({
          :position => Vec2.new(@tile_position_offset, @tile_height_offset), 
        })
        tile = TestGame::Block.new(tile_properties)
        tile.parent = self
        screen << tile

        tile_properties = @tile_base_properties.merge({
          :position => Vec2.new(@tile_position_offset, @tile_height_offset + 1 * @tile_height), 
          :sprite_relative_offset => @underground_tile_offset,
          :collidable => false
        })
        tile = TestGame::Block.new(tile_properties)
        tile.parent = self
        screen << tile

        tile_properties = @tile_base_properties.merge({
          :position => Vec2.new(@tile_position_offset, @tile_height_offset + 2 * @tile_height), 
          :sprite_relative_offset => @underground_tile_offset,
          :collidable => false
        })
        tile = TestGame::Block.new(tile_properties)
        tile.parent = self
        screen << tile

        tile_properties = @tile_base_properties.merge({
          :position => Vec2.new(@tile_position_offset, @tile_height_offset + 3 * @tile_height), 
          :sprite_relative_offset => @underground_tile_offset,
          :collidable => false
        })
        tile = TestGame::Block.new(tile_properties)
        tile.parent = self
        screen << tile

        @tile_offset += 1
      end

      screen
    end

    def remove(child)
      @screens.each do |screen|
        screen.delete(child) if screen.include?(child)
      end
    end

    def tiles_required?
      (Application.render_manager.camera.bounds.x + @tile_width) > (@tile_position_offset)
    end

    def cleanup_old_tiles
      @screens = @screens.slice(1, @screens.length - 1)
    end

    def submit_render
      @screens.each do |screen|
        screen.each do |tile|
          tile.submit_render
        end
      end
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
