TestGame::Application.screen_manager.define_screen(:pause_screen) do
  button('start_button', :z_index => 1.0, :position => Vec2.new(0, 400), :centered => :horizontal) do
    TestGame::Application.screen_manager.current.resume
  end

  button('start_button', :z_index => 1.0, :position => Vec2.new(0, 500), :centered => :horizontal) do
    TestGame::Application.current.quit
  end
end
