Game::Application.configure do
  conf[:title] = "Game is the coolest game ever"
  conf[:window_flags] = [:shown, :resizable, :opengl]
  conf[:start_size] = [800, 600]

  if platform.mobile?
    conf[:input] = []
  elsif platform.desktop?
    conf[:input] = []
  end

end
