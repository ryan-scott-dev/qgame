module QGame
  class KeyboardInput
    def is_down?(input_alias)
      input_alias.nil? ? false : SDL.key_state_from_name(input_alias) 
    end
  end

  class GamepadInput
  end

  class VirtualGamepadInput
  end

  class InputMapping
    def initialize(input_klass, &block)
      Input.create_mapping(input_klass, self)
      @input_manager = input_klass.new
      @key_mapping = {}

      instance_eval(&block)
    end

    def map(input_mapping)
      puts input_mapping
      input_mapping.each do |key, input_alias|
        @key_mapping[input_alias] = key
      end
    end
    
    def input_map
      @key_mapping
    end

    def map_like(other)
      map(Input.fetch_mapping(other).input_map)
    end

    def is_down?(input_alias)
      @input_manager.is_down? @key_mapping[input_alias]
    end
  end

  class Input
    def self.setup(input_options)
      input_options = [input_options] unless input_options.is_a? Array
      @input_types = input_options.map {|input_option| fetch_mapping(input_klass(input_option))}
    end

    def self.input_klass(input_option)
      case input_option
      when :keyboard
        KeyboardInput
      when :virtual_gamepad
        VirtualGamepadInput
      end
    end

    def self.create_mapping(input_klass, instance)
      @mapping = {} if @mapping.nil?
      @mapping[input_klass] = instance
    end

    def self.fetch_mapping(input_klass)
      @mapping[input_klass]
    end

    def self.input_types
      @input_types
    end

    def self.is_down?(input_alias)
      input_types.any? {|input_type| input_type.is_down?(input_alias)}
    end
  end
end
