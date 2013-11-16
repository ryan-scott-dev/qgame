TestGame::Application.scenario_manager.define_scenario(:test_3d) do  

  player = TestGame::TestPlayer.new(:position => Vec3.new(0, 2, 0))
  add(player)

  camera(TestGame::GameCamera.new(:follow => player))
  perspective

  # add(TestGame::TestCube.new(:position => Vec3.new(0, 0, 0),
  #                            :texture => QGame::AssetManager.texture('wood')))

  # add(TestGame::TestCube.new(:position => Vec3.new(0, 0, 4),
  #                            :texture => QGame::AssetManager.texture('wood')))

  # add(TestGame::TestCube.new(:position => Vec3.new(0, 4, 0),
  #                            :texture => QGame::AssetManager.texture('wood')))

  # add(TestGame::TestCube.new(:position => Vec3.new(0, 4, 4),
  #                            :texture => QGame::AssetManager.texture('wood')))

  # add(TestGame::TestCube.new(:position => Vec3.new(4, 0, 0),
  #                            :texture => QGame::AssetManager.texture('wood')))

  # add(TestGame::TestCube.new(:position => Vec3.new(4, 0, 4),
  #                            :texture => QGame::AssetManager.texture('wood')))

  # add(TestGame::TestCube.new(:position => Vec3.new(4, 4, 0),
  #                            :texture => QGame::AssetManager.texture('wood')))

  # add(TestGame::TestCube.new(:position => Vec3.new(4, 4, 4),
  #                            :texture => QGame::AssetManager.texture('wood')))
  

  add(TestGame::TestPlane.new(:texture => QGame::AssetManager.texture('wood')))
end
