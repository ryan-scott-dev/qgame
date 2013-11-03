TestGame::Application.scenario_manager.define_scenario(:test_3d) do  
  camera(:lookat, :position => Vec3.new(0, 0, 10))
  perspective

  add(TestGame::TestCube.new(:texture => QGame::AssetManager.texture('wood')))
end
