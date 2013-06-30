Game::Application.run do
  # Full application lifecycle
  @running = true

  Game::RenderManager.camera = Game::Camera2D.new(:position => Vec2.new(100, 0))

  on_event :quit do |event|
    @running = false
  end

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

  on_event :window_resized do |event|
    Game::RenderManager.resize_window(event.resize_width, event.resize_height)
  end

  sprites = []
  size = 60
  (1..10).each do |offset_x|
    (1..10).each do |offset_y|
      sprites << Game::WoodSprite.new(:position => Vec2.new(offset_x * size, offset_y * size), 
        :scale => Vec2.new(size))
    end
  end

  state = Game::Menu.find('main').build

  while(@running)
    handle_events

    # update
    sprites.each do |sprite|
      sprite.update
    end

    state.update

    # render
    GL.clear_color(0.713, 0.788, 0.623, 1)
    GL.clear [:color]

    # render logic
    Game::RenderManager.render

    @window.swap_gl_window

    SDL.delay(16)

    error = GL.error
    unless error.nil?
      puts "GL Error: #{error} - Found during game loop"
    end
  end

  # End of application lifecycle
  quit
end
