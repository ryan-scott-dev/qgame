$PROJ_NAME::Application.screen_manager.define_screen(:game) do
  camera(:fixed)
  
  test_sprite = QGame::AnimatedSprite.new(:position => Vec2.new(100, 300), 
        :texture => QGame::AssetManager.texture('test_sprite'), 
        :frame_size => Vec2.new(60, 60),
        :frame_rate => 20)
  add(test_sprite)
end
