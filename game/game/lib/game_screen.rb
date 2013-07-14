QGame::Screen.new(:game) do
  player = Game::Player.new(:position => Vec2.new(300, 300))
  handle_events player
  @components << player

  level_generator = Game::LevelGenerator.new
  @components << level_generator

  camera(:follow, :target => player)
  overlay(:virtual_gamepad) if Game::Input.input_type_active? :virtual_gamepad
end
