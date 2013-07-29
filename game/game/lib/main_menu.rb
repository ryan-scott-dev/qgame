QGame::Screen.new(:main_menu) do
  transition(:out) do |to|
    animate(:transparency).from(0).to(1)
                          .over(1.second)
                          .on_tick { |new_value| to.alpha = 1 - new_value}
  end

  camera(:fixed)

  text('Eddy Example', :font => './assets/fonts/ObelixPro.ttf', 
       :font_size => 42, :flag => :cartoon, :position => Vec2.new(0, 200))

  button('start_button', :position => Vec2.new(0, 200), :centered => :horizontal) do
    Game::ScreenManager.transition_to(:game)
  end
end
