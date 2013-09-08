Game.testing_things

module TestGame
  Application.run do
    # Full application lifecycle
    GL.set_clear_color(0.713, 0.788, 0.623)
    GL.set_clear_flags([:color, :depth])
    
    @running = true

    if ARGV.include? 'analyse'
      puts "Running in analysis mode"
      QGame::AnalysisScreen.enable 
    end

    scenario_arg = ARGV.select{|arg| arg.include? '--scenario='}.first
    if scenario_arg
      scenario_name = scenario_arg.gsub('--scenario=', '')
      scenario = QGame::Scenario.find(scenario_name.to_sym)
    end

    QGame::ConsoleOverlayScreen.enable

    on_event :quit do |event|
      @running = false
    end

    on_event :window_resized do |event|
      Application.render_manager.resize_window(event.resize_width, event.resize_height)
    end

    if scenario
      QGame::ScenarioScreen.enable(scenario)
    else
      Application.screen_manager.transition_to(:main_menu)
    end

    handle_events Application.screen_manager
    
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
        QGame::Application.screen_manager.update
        
        frame_time -= @elapsed
      end

      # render
      GL.clear

      # render logic
      QGame::Application.screen_manager.submit_render
      QGame::Application.render_manager.render

      @window.swap_gl_window

      error = GL.error
      unless error.nil?
        puts "GL Error: #{error} - Found during game loop"
      end
    end

    # End of application lifecycle
    cleanup
  end
end