TestGame::Application.screen_manager.define_screen(:virtual_gamepad) do  
  joystick('virtual_thumbstick', :position => Vec2.new(100, 400))
end
