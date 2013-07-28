QGame::Screen.new(:main_menu) do
  camera(:fixed)

  text('Eddy Example', :font_size => 42, :position => Vec2.new(0, 200), :centered => :horizontal)

  button('start_button', :position => Vec2.new(0, 400), :centered => :horizontal) do
    Game::ScreenManager.transition_to(:game)
  end
end
