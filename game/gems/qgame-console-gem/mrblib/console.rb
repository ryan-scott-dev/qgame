module QGame
  class Console < TextInput
    def initialize(args = {})
      @history = []

      super
    end

    def handle_key_down(event)
      case event.key
      when :return
        execute_from_buffer

        @history << @buffer
        @buffer = ''
        @text_display.text = @buffer
      end

      super
    end

    def execute_from_buffer
      eval(@buffer)
    end
  end

  class Screen
    def console(args = {})
      new_text_input = QGame::Console.new(args)

      on_event(:mouse_up) do |event|
        new_text_input.handle_mouse_up(event)
      end

      on_event(:key_down) do |event|
        new_text_input.handle_key_down(event)
      end

      on_event(:text_input) do |event|
        new_text_input.handle_text_input(event)
      end

      on_event(:text_editing) do |event|
        new_text_input.handle_editing(event)
      end

      add(new_text_input)
      new_text_input
    end
  end
end