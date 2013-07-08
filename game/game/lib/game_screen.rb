QGame::Screen.new(:game) do
  camera(:fixed)

  player = Game::Player.new(:position => Vec2.new(300, 200))
  handle_events player
  @components << player

  # size = 60
  # max_x = (screen_width / size).to_i
  # max_y = (screen_height / size).to_i

  # (0..max_x).each do |offset_x|
  #   (0..max_y).each do |offset_y|
  #     @components << Game::WoodSprite.new(:position => Vec2.new(offset_x * size, offset_y * size), 
  #       :scale => Vec2.new(size))
  #   end
  # end

  @components << Game::Coin.new(:position => Vec2.new(100, 200))
  @components << Game::Coin.new(:position => Vec2.new(120, 200))
  @components << Game::Coin.new(:position => Vec2.new(140, 200))
  @components << Game::Coin.new(:position => Vec2.new(160, 200))
  @components << Game::Coin.new(:position => Vec2.new(180, 200))

end
