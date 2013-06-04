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
  end

  # End of application lifecycle
  quit
end
