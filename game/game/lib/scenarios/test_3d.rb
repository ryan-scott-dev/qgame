TestGame::Application.scenario_manager.define_scenario(:test_3d) do  
  camera(:lookat, :position => Vec3.new(0, 10, 10), :target => Vec3.new(0))
  perspective

  add(TestGame::TestCube.new(:texture => QGame::AssetManager.texture('wood')))
end
