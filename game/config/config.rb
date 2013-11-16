TestGame::Application.configure do
  conf[:title] = "Game is the coolest game ever"
  conf[:window_flags] = [:shown, :resizable, :opengl]
  conf[:start_size] = [800, 600]  

  if profile.mobile?
    conf[:input] = []
  elsif profile.desktop?
    conf[:input] = [:keyboard, :mouse]
  end

end
