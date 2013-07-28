QGame::Screen.new(:pause_screen) do
  button('start_button', :position => Vec2.new(0, 400), :centered => :horizontal) do
    Game::ScreenManager.current.resume
  end

  button('start_button', :position => Vec2.new(0, 500), :centered => :horizontal) do
    Game::Application.current.quit
  end
end