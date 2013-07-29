QGame::Screen.new(:game_over) do
  text('Eddy Example', :z_index => 1.0, :font => './assets/fonts/ObelixPro.ttf', 
       :font_size => 42, :flag => :cartoon, :position => Vec2.new(0, 200))

  button('start_button', :z_index => 1.0, :position => Vec2.new(0, 200), :centered => :horizontal) do
    Game::ScreenManager.current.overlay(nil)
    Game::ScreenManager.transition_to(:game)
  end
end
