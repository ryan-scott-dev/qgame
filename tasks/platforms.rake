class Platform
  attr_accessor :name, :build_target

  def self.host_ruby_platform_to_qgame_platform
    case
    when RUBY_PLATFORM.downcase.include?("darwin")
      return :osx
    when RUBY_PLATFORM.downcase.include?("linux")
      return :linux
    when RUBY_PLATFORM.downcase.include?("w32")
      return :win
    end
    return :unknown
  end

  def self.host_platform
    platform_for(host_ruby_platform_to_qgame_platform)
  end

  def self.platform_for(platform_name)
    platform_name = platform_name.to_sym if platform_name.is_a? String
    platform_name ? supported[platform_name] : nil
  end

  def self.supported
    @@platforms ||= {
      :osx => PlatformOSX.new,
      :ios => PlatformIOS.new,
      :win => PlatformWin.new,
      :unknown => PlatformUnknown.new
    }
  end

  def is_ios?
    false
  end

  def is_cygwin?
    false
  end
end

class PlatformOSX < Platform
  def initialize
    @name = :osx
    @build_target = Platform.host_ruby_platform_to_qgame_platform == :osx ? :host : :osx
  end
end

class PlatformIOS < Platform
  def initialize
    @name = :ios
    @build_target = :ios_i386
  end

  def is_ios?
    true
  end
end

class PlatformWin < Platform
  def initialize
    @name = :win
    @build_target = Platform.host_ruby_platform_to_qgame_platform == :win ? :host : :win
  end

  def is_cygwin?
    true
  end
end

class PlatformUnknown < Platform
  def initialize
    @name = :unknown
    @build_target = nil
  end
end
