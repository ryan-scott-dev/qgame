Game::Application.run do |app|
  # Full application lifecycle
  @running = true

  app.on_event :quit do |event|
    @running = false
  end

  while(@running)
    app.handle_events

    # update
    # render
  end

  # End of application lifecycle
  app.quit
end
