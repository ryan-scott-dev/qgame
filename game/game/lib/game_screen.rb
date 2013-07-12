QGame::Screen.new(:game) do
  player = Game::Player.new(:position => Vec2.new(300, 200))
  handle_events player
  @components << player

  camera(:follow, :target => player)

  @components << Game::Coin.new(:position => Vec2.new(100, 200))
  @components << Game::Coin.new(:position => Vec2.new(120, 200))
  @components << Game::Coin.new(:position => Vec2.new(140, 200))
  @components << Game::Coin.new(:position => Vec2.new(160, 200))
  @components << Game::Coin.new(:position => Vec2.new(180, 200))

  overlay(:virtual_gamepad) if Game::Input.input_type_active? :virtual_gamepad
end
