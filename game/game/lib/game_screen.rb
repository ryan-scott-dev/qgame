QGame::Screen.new(:game) do
  camera(:fixed)

  on_event :key_down do |event|
    if event.key == :left  
      Game::RenderManager.camera.position.x -= 10
    elsif event.key == :right
      Game::RenderManager.camera.position.x += 10
    end

    if event.key == :up  
      Game::RenderManager.camera.position.y -= 10
    elsif event.key == :down
      Game::RenderManager.camera.position.y += 10
    end
  end

  size = 60
  max_x = (screen_width / size).to_i
  max_y = (screen_height / size).to_i

  (0..max_x).each do |offset_x|
    (0..max_y).each do |offset_y|
      @components << Game::WoodSprite.new(:position => Vec2.new(offset_x * size, offset_y * size), 
        :scale => Vec2.new(size))
    end
  end
end
