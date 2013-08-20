$PROJ_NAME::Application.configure do
  conf[:title] = "This game is going to be my best game yet!"
  conf[:window_flags] = [:shown, :resizable, :opengl]
  conf[:start_size] = [800, 600]  

  if profile.mobile?
    conf[:input] = []
  elsif profile.desktop?
    conf[:input] = []
  end

end
