Game::Application.configure do
  conf[:title] = "Game is the coolest game ever"
  conf[:window_flags] = [:shown, :resizable, :opengl]
  conf[:start_size] = [800, 600]

  if platform.mobile?
    conf[:input] = :virtual_gamepad
  elsif platform.desktop?
    conf[:input] = [:keyboard]
  end

end
