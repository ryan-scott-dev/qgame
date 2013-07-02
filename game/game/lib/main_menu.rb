QGame::Screen.new(:main_menu) do
  camera(:fixed)

  image('menu_title', :position => Vec2.new(400, 200))

  button('start_button', :position => Vec2.new(400)) do
    Game::ScreenManager.transition_to(:game)
  end

  # button('') do
  # end
  
  # button('') do
  # end

end
