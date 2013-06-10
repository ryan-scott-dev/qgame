Game::Application.run do
  # Full application lifecycle
  @running = true

  on_event :quit do |event|
    @running = false
  end

  sprite = Game::Sprite.new

  while(@running)
    handle_events

    # update
    sprite.update

    # render
    GL.clear_color(0, 0, 0, 1)
    GL.clear [:color]

    # render logic
    Game::RenderManager.render

    @window.swap_gl_window

    SDL.delay(16)
  end

  # End of application lifecycle
  quit
end
