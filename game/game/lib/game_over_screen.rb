QGame::Screen.new(:game_over) do

  text("Score: #{Game::Player.current.score}", :z_index => 1.0, :position => Vec2.new(0, 100), :font_size => 24,
    :centered => :horizontal)

  text('Eddy Example', :z_index => 1.0, :font => './assets/fonts/ObelixPro.ttf', 
       :font_size => 42, :flag => :cartoon, :position => Vec2.new(0, 200), :centered => :horizontal)

  button('start_button', :z_index => 1.0, :position => Vec2.new(0, 200), :centered => :horizontal) do
    Game::ScreenManager.current.overlay(nil)
    Game::ScreenManager.transition_to(:game)
  end
end
