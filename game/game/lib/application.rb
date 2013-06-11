Game::Application.run do
  # Full application lifecycle
  @running = true

  on_event :quit do |event|
    @running = false
  end

  sprite = Game::Sprite.new(:texture => Game::AssetManager.texture('wood'))

  while(@running)
    handle_events

    # update
    sprite.update

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
