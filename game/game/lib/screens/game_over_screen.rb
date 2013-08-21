TestGame::Application.screen_manager.define_screen(:game_over) do
  text("Score: #{TestGame::Player.current.score}", :z_index => 1.0, :position => Vec2.new(0, 100), :font_size => 24,
    :centered => :horizontal)

  text('Eddy Example', :z_index => 1.0, :font => './assets/fonts/ObelixPro.ttf', 
       :font_size => 42, :flag => :cartoon, :position => Vec2.new(0, 200), :centered => :horizontal)

  button('start_button', :z_index => 1.0, :position => Vec2.new(0, 200), :centered => :horizontal) do
    TestGame::Application.screen_manager.current.overlay(nil)
    TestGame::Application.screen_manager.transition_to(:game)
  end
end
