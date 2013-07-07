module QGame
  class Platform
    attr_accessor :name

    def self.current
      Platform.new
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
