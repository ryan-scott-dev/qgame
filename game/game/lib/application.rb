Game.testing_things

TestGame::Application.run do
  # Full application lifecycle
  GL.set_clear_color(0.713, 0.788, 0.623)
  GL.set_clear_flags([:color, :depth])
  
  @running = true

  if ARGV.include? 'analyse'
    puts "Running in analysis mode"
    QGame::AnalysisScreen.enable 
  end

  on_event :quit do |event|
    @running = false
  end

  on_event :window_resized do |event|
    QGame::RenderManager.resize_window(event.resize_width, event.resize_height)
  end

  QGame::ScreenManager.transition_to(:main_menu)

  handle_events QGame::ScreenManager
  
  timestep = 1.0 / 60.0
  @elapsed = 0.0
  current_time = Time.now
  
  while(@running)
    process_events

    new_time = Time.now
    frame_time = new_time - current_time
    current_time = new_time

    while ( frame_time > 0.0 )
      @elapsed = Math.min(frame_time, timestep)

      # update
      QGame::ScreenManager.update

      frame_time -= @elapsed
    end

    # render
    GL.clear

    # render logic
    QGame::ScreenManager.submit_render
    QGame::RenderManager.render

    @window.swap_gl_window

    error = GL.error
    unless error.nil?
      puts "GL Error: #{error} - Found during game loop"
    end
  end

  # End of application lifecycle
  cleanup
end
