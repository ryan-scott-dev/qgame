def default_platform
  case 
  when RUBY_PLATFORM.downcase.include?("darwin")
    return :osx
  when RUBY_PLATFORM.downcase.include?("linux")
    return :linux
  when RUBY_PLATFORM.downcase.include?("mswin")
    return :win
  end
end

def platforms
  [:osx, :linux, :win, :ios]
end