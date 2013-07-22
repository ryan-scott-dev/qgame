QGame::Screen.new(:game) do
  
  player = Game::Player.new(:position => Vec2.new(300, 300))

  level_generator = Game::LevelGenerator.new(player)
  @components << level_generator
  
  handle_events player
  @components << player

  dynamic_text(:frequency => 0.1, :position => Vec2.new(20), :font_size => 16) do
    "Score: #{player.score}"
  end

  camera(:follow, :target => player)
  overlay(:virtual_gamepad) if Game::Input.input_type_active? :virtual_gamepad
end
