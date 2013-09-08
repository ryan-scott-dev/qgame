TestGame::Application.scenario_manager.define_scenario(:jumping_collisions) do
  text('Eddy Example', :z_index => 1.0, :font => './assets/fonts/ObelixPro.ttf', 
       :font_size => 42, :flag => :cartoon, :position => Vec2.new(0, 200), :centered => :horizontal)
end
