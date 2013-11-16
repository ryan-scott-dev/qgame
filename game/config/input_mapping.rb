TestGame::InputMapping.new(QGame::KeyboardInput) do
  map :a => :move_left
  map :left => :move_left

  map :d => :move_right
  map :right => :move_right

  map :w => :move_forward
  map :up => :move_forward

  map :s => :move_backward
  map :down => :move_backward

  map :space => :jump

  map ['left shift', :`] => :dev_console
  map ['right shift', :`] => :dev_console
end

TestGame::InputMapping.new(QGame::MouseInput) do
  map :mouse_wheel => :camera_zoom
end

TestGame::InputMapping.new(QGame::GamepadInput) do
  map :left => :move_left
  map :right => :move_right

  map :a => :jump
end

TestGame::InputMapping.new(QGame::VirtualGamepadInput) do
  map_like QGame::GamepadInput
end
