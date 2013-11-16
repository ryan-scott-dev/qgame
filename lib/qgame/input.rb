module QGame
  class BaseInput
    def initialize(input_mapping)
      @input_mapping = input_mapping
      @handlers = {}
    end

    def attach_handler(input_alias, &block)
      @handlers[input_alias] ||= []
      @handlers[input_alias] << block
    end

    def responds_to?(input_alias)
      @input_mapping.responds_to?(input_alias)
    end

    def raise_input_for_key(key, event)
      input_aliases = @input_mapping.aliases_for_key([key])
      input_aliases.each do |input_alias|
        raise_input(input_alias, event)
      end
    end

    def raise_input(input_alias, event)
      return false unless responds_to?(input_alias)
      return false if @handlers[input_alias].nil?

      @handlers[input_alias].each do |callback|
        callback.call(event)
      end
    end

    def start
    end

    def update
    end
  end

  class KeyboardInput < BaseInput
    def is_down?(input_alias)
      return false if input_alias.nil?

      if input_alias.is_a?(Symbol) || input_alias.is_a?(String)
        return SDL.key_state_from_name(input_alias.to_s)
      elsif input_alias.is_a?(Array)
        return input_alias.all? { |key| is_down?(key) }
      end
    end
  end

  class MouseInput < BaseInput
    def start
      QGame::Application.current.on_event(:mouse_down) do |event|
        handle_mouse_down(event)
      end

      QGame::Application.current.on_event(:mouse_up) do |event|
        handle_mouse_up(event)
      end

      QGame::Application.current.on_event(:mouse_moved) do |event|
        handle_mouse_motion(event)
      end

      QGame::Application.current.on_event(:mouse_wheel) do |event|
        handle_mouse_wheel(event)
      end
    end

    def handle_mouse_motion(event)
      if event.is_mouse_left_down?
        raise_input_for_key(:drag, event)
      end

      if !event.handled
        raise_input_for_key(:motion, event)
      end
    end

    def handle_mouse_wheel(event)
      raise_input_for_key(:mouse_wheel, event)
    end

    def handle_mouse_up(event)
      raise_input_for_key(:up, event)
    end

    def handle_mouse_down(event)
      raise_input_for_key(:down, event)

      if !event.handled
        if event.is_mouse_left_down?
          raise_input_for_key(:left_down, event)
        end
      end
    end

    def update
      if SDL.is_mouse_left_down?
        raise_input_for_key(:left_held, SDL::Event.new)
      end

      super
    end

    def self.mouse_position
      Vec2.new(SDL.mouse_position_x, SDL.mouse_position_y)
    end
  end

  class TouchInput < BaseInput
  end

  class GamepadInput < BaseInput
  end

  class VirtualGamepadInput < BaseInput
    def initialize(input_mapping)
      super

      @input_states = {}
    end

    def change_input_state(input_alias, state)
      @input_states[input_alias] = state
    end

    def is_down?(input_alias)
      @input_states[input_alias]
    end
  end

  class InputMapping
    attr_accessor :input_manager

    def initialize(input_klass, &block)
      Input.create_mapping(input_klass, self)
      @input_manager = input_klass.new(self)
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

    def aliases_for_key(key)
      aliases = []
      @key_mapping.each do |input_alias, mapped_key|
        aliases << input_alias if key == mapped_key
      end
      aliases
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
      return false unless responds_to?(input_alias)

      @key_mapping[input_alias].any? {|key| @input_manager.is_down? key}
    end

    def responds_to?(input_alias)
      return @key_mapping.has_key?(input_alias)
    end

    def attach_handler(input_alias, &block)
      return false unless responds_to?(input_alias)

      @input_manager.attach_handler(input_alias, &block)
    end

    def update
      @input_manager.update
    end

    def start
      @input_manager.start
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
      when :mouse
        MouseInput
      when :touch
        TouchInput
      when :gamepad
        GamepadInput
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

    def self.on(input_alias, &block)
      input_types.each {|input_type| input_type.attach_handler(input_alias, &block)}
    end

    def self.update
      input_types.each {|input_type| input_type.update }
    end

    def self.start
      input_types.each {|input_type| input_type.start }
    end
  end
end
