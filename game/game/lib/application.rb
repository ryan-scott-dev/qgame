Game::Application.run do
  # Full application lifecycle
  @running = true

  if ARGV.include? 'profile'
    puts "Running in profile mode"
    QGame::ProfileScreen.enable 
  end

  on_event :quit do |event|
    @running = false
  end

  on_event :window_resized do |event|
    Game::RenderManager.resize_window(event.resize_width, event.resize_height)
  end

  Game::ScreenManager.transition_to(:main_menu)

  handle_events Game::ScreenManager
  
  while(@running)
    stop_elapsed_counter
    process_events

    # update
    Game::ScreenManager.update
    start_elapsed_counter

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
