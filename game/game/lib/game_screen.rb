QGame::Screen.new(:game) do
  
  player = Game::Player.new(:position => Vec2.new(50, 300))

  level_generator = Game::LevelGenerator.new(player)
  @components << level_generator
  
  handle_events player
  @components << player

  dynamic_text(:frequency => 0.1, :position => Vec2.new(20), :font_size => 16) do
    "Score: #{player.score}"
  end

  button('pause_icon', :position => Vec2.new(128, 64)) do
    Game::ScreenManager.current.pause
    Game::ScreenManager.current.overlay(:pause_screen)
  end

  test = Game::Test.new(:position => Vec2.new(100, 300))
  @components << test

  camera(:follow, :target => player)
  overlay(:virtual_gamepad) if Game::Input.input_type_active? :virtual_gamepad
end
