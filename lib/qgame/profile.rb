module QGame
  class Profile
    attr_accessor :name

    def self.current
      Profile.new
    end

    def initialize
      @name = SDL.platform
    end

    def desktop?
      case name
      when "Linux"
        true
      when "Mac OS X"
        true
      when "Windows"
        true
      else
        false
      end
    end

    def mobile?
      case name
      when "Android"
        true
      when "iPhone OS"
        true
      else
        false
      end
    end

  end
end
