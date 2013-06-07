Game::Application.run do
  # Full application lifecycle
  @running = true

  on_event :quit do |event|
    @running = false
  end

  while(@running)
    handle_events

    # update

    # render
    GL.clear_color(0.713, 0.788, 0.623, 1)
    GL.clear [:color]

    # render logic

    @window.swap_gl_window

    SDL.delay(16)
  end

  # End of application lifecycle
  quit
end
