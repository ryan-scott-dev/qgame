TestGame::Application.scenario_manager.define_scenario(:test_3d) do  
  camera(:lookat, :position => Vec3.new(20), :target => Vec3.new(0))
  perspective

  add(TestGame::TestCube.new(:position => Vec3.new(0, 0, 0),
                             :texture => QGame::AssetManager.texture('wood')))

  add(TestGame::TestCube.new(:position => Vec3.new(0, 0, 4),
                             :texture => QGame::AssetManager.texture('wood')))

  add(TestGame::TestCube.new(:position => Vec3.new(0, 4, 0),
                             :texture => QGame::AssetManager.texture('wood')))

  add(TestGame::TestCube.new(:position => Vec3.new(0, 4, 4),
                             :texture => QGame::AssetManager.texture('wood')))

  add(TestGame::TestCube.new(:position => Vec3.new(4, 0, 0),
                             :texture => QGame::AssetManager.texture('wood')))

  add(TestGame::TestCube.new(:position => Vec3.new(4, 0, 4),
                             :texture => QGame::AssetManager.texture('wood')))

  add(TestGame::TestCube.new(:position => Vec3.new(4, 4, 0),
                             :texture => QGame::AssetManager.texture('wood')))

  add(TestGame::TestCube.new(:position => Vec3.new(4, 4, 4),
                             :texture => QGame::AssetManager.texture('wood')))

  add(TestGame::TestPlane.new(:texture => QGame::AssetManager.texture('wood')))
end
