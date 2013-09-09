TestGame::Application.scenario_manager.define_scenario(:jumping_collisions) do  
  level_generator = TestGame::LevelGenerator.new(nil)
  add(level_generator)

  camera(:fixed)

  test = TestGame::Test.new(:position => Vec2.new(100, 300))
  add(test)

  test = TestGame::Test.new(:position => Vec2.new(200, 300))
  add(test)

  test = TestGame::Test.new(:position => Vec2.new(300, 300))
  add(test)
end
