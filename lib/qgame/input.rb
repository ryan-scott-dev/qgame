module QGame
  class KeyboardInput
    def is_down?(input_alias)
      return false if input_alias.nil?

      if input_alias.is_a?(Symbol) || input_alias.is_a?(String)
        return SDL.key_state_from_name(input_alias.to_s)
      elsif input_alias.is_a?(Array)
        return input_alias.all? { |key| is_down?(key) }
      end
    end
  end

  class MouseInput
    def self.mouse_position
      Vec2.new(SDL.mouse_position_x, SDL.mouse_position_y)
    end
  end

  class GamepadInput
  end

  class VirtualGamepadInput
    def initialize
      @input_states = {}
    end

    def change_input_state(input_alias, state)
      @input_states[input_alias] = state
    end

    def is_down?(input_alias)
      @input_states.has_key?(input_alias) && @input_states[input_alias]
    end
  end

  class InputMapping
    attr_accessor :input_manager

    def initialize(input_klass, &block)
      Input.create_mapping(input_klass, self)
      @input_manager = input_klass.new
      @key_mapping = {}

      instance_eval(&block)
    end

    def map(input_mapping)
      input_mapping.each do |key, input_alias|
        @key_mapping[input_alias] = [] if @key_mapping[input_alias].nil?
        @key_mapping[input_alias] << key
      end
    end

    def input_map
      @key_mapping
    end

    def map_like(other)
      input_mapping = Input.fetch_mapping_for_class(other).input_map
      
      input_mapping.each do |input_alias, keys|
        keys.each do |key|
          @key_mapping[input_alias] = [] if @key_mapping[input_alias].nil?
          @key_mapping[input_alias] << key
        end  
      end
    end

    def is_down?(input_alias)
      return false unless @key_mapping.has_key? input_alias

      @key_mapping[input_alias].any? {|key| @input_manager.is_down? key}
    end
  end

  class Input
    def self.setup(input_options)
      input_options = [input_options] unless input_options.is_a? Array
      @input_options = input_options
      @input_types = @input_options.map {|input_option| fetch_mapping(input_option)}
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

    def self.fetch_mapping(input_option)
      fetch_mapping_for_class(input_klass(input_option))
    end

    def self.fetch_mapping_for_class(input_klass)
      @mapping[input_klass]
    end

    def self.input_types
      @input_types
    end

    def self.input_type_active?(input_type)
      @input_options.include? input_type
    end

    def self.is_down?(input_alias)
      input_types.any? {|input_type| input_type.is_down?(input_alias)}
    end
  end
end
