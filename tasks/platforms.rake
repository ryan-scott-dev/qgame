#TODO: RS - Encapsulate into its own class

class Platform
  attr_accessor :name

  def self.host_platform
    case 
    when RUBY_PLATFORM.downcase.include?("darwin")
      return platform_for(:osx)
    when RUBY_PLATFORM.downcase.include?("linux")
      return platform_for(:linux)
    when RUBY_PLATFORM.downcase.include?("mswin")
      return platform_for(:win)
    end
  end

  def self.platform_for(platform_name)
    platform_name = platform_name.to_sym if platform_name.is_a? String
    platform_name ? supported[platform_name] : nil
  end
  
  def self.supported
    @@platforms ||= {
      :osx => PlatformOSX.new,
      :ios => PlatformIOS.new,
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
  end
end

class PlatformIOS < Platform
  def initialize
    @name = :ios
  end

  def is_ios?
    true
  end
end

class PlatformUnknown < Platform
  def initialize
    @name = :unknown
  end
end
