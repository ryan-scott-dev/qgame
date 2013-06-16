Game::Application.run do
  # Full application lifecycle
  @running = true

  on_event :quit do |event|
    @running = false
  end

  sprites = []
  size = 60
  (1..10).each do |offset_x|
    (1..10).each do |offset_y|
      sprites << Game::WoodSprite.new(:position => Vec2.new(offset_x * size, offset_y * size), 
        :scale => Vec2.new(size))
    end
  end
  

  while(@running)
    handle_events

    # update
    sprites.each do |sprite|
      sprite.update
    end

    # render
    GL.clear_color(0.713, 0.788, 0.623, 1)
    GL.clear [:color]

    # render logic
    Game::RenderManager.render

    @window.swap_gl_window

    SDL.delay(16)

    error = GL.error
    unless error.nil?
      puts "GL Error: #{error}"
    end
  end

  # End of application lifecycle
  quit
end
