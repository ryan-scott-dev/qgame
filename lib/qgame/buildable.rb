module QGame
  module Buildable
    attr_accessor :built

    def reset
      build
    end

    def build
      destruct

      self.instance_eval(&@configure)
      @built = true
      self
    end
  end
end
