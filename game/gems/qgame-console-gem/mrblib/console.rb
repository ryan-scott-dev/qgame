module QGame
  class Console < TextInput
    def initialize(args = {})
      @history = []
      @history_offset = 0

      super
    end

    def handle_key_down(event)
      case event.key
      when :return
        execute_from_buffer
        append_buffer_to_history
        clear_buffer
      when :up
        buffer_to_history_previous
      when :down
        buffer_to_history_next
      end

      super
    end

    def buffer_to_history_previous
      if @history_offset > 0
        @history_offset -= 1
        update_buffer_to_history_offset
      end
    end

    def buffer_to_history_next
      if @history_offset < @history.size - 1
        @history_offset += 1
        update_buffer_to_history_offset
      end
    end

    def update_buffer_to_history_offset
      @buffer = @history[@history_offset]
      @text_display.text = @buffer
    end

    def append_buffer_to_history
      @history << @buffer
      @history_offset = @history.size
    end

    def clear_buffer
      @buffer = ''
      @text_display.text = @buffer
    end

    def execute_from_buffer
      begin
        puts "> #{@buffer}"
        result = eval(@buffer)
      rescue Exception => e
        puts "Error: #{e.message}"
        return
      end

      puts " => #{result.inspect}"
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