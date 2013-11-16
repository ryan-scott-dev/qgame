module QGame
  module BuildableHelpers

    def camera(type, args = {})
      if type.is_a? Symbol
        case type
        when :fixed 
          @camera = Application.render_manager.camera = QGame::Camera2D.new(args)
        when :follow
          @camera = Application.render_manager.camera = QGame::FollowCamera.new(args)
        when :lookat
          @camera = Application.render_manager.camera = QGame::LookAtCamera.new(args)
        when :follow_3d
          @camera = Application.render_manager.camera = QGame::FollowCamera3D.new(args)
        end
      else
        @camera = Application.render_manager.camera = type
      end

      @camera
    end

    def screen_width
      Application.render_manager.screen_width
    end

    def screen_height
      Application.render_manager.screen_height
    end

    def screen_center
      Vec2.new((screen_height / 2.0), (screen_width / 2.0))
    end

    def perspective
      Application.render_manager.perspective
    end

    def center_horizontal_position
      Vec2.new(screen_center.x, 0)
    end

    def center_position_from_size(size)
      Vec2.new((screen_width / 2) - (size.x / 2), (screen_height / 2) - (size.y / 2))
    end

    def centered_args_from_texture(args)
      if args.has_key? :centered
        args[:position] = Vec2.new unless args.has_key? :position

        case args[:centered]
        when :horizontal
          args[:position].x = screen_center.x
        when :vertical  
          args[:position].y = screen_center.y
        when :both
          args[:position] = screen_center
        end

        args = args.reject!{ |k| k == :centered }
      end

      args
    end

    def dynamic_text(args = {}, &block)
      new_text = QGame::DynamicText.new(args, &block)
      add(new_text)
    end

    def image(texture_name, args = {})
      texture = QGame::AssetManager.texture(texture_name)

      args = centered_args_from_texture(args)

      new_image = QGame::Sprite.new({:texture => texture, :scale => texture.size}.merge(args))
      add(new_image)
      new_image
    end

    def button(texture_name, args = {}, &block)
      texture = QGame::AssetManager.texture(texture_name)
      texture_pressed = QGame::AssetManager.texture("#{texture_name}_pressed")

      # args = centered_args_from_texture(args)

      new_button = QGame::Button.new({:screen_space => true, :texture => texture, :texture_pressed => texture_pressed, 
        :scale => texture.size, :mode => :on_release}.merge(args), &block)
      apply_float(args[:float], new_button)

      on_event(:mouse_up) do |event|
        new_button.handle_mouse_up(event)
      end

      on_event(:mouse_down) do |event|
        new_button.handle_mouse_down(event)
      end

      add(new_button)
      new_button
    end

    def text(text, args = {}) 
      new_text = QGame::Text.new({:text => text}.merge(args))
      apply_float(args[:float], new_text)
      add(new_text)
      new_text
    end

    def text_input(args = {})
      new_text_input = QGame::TextInput.new(args)

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

    def ticker_graph(args = {}, &block)
      new_graph = QGame::TickerGraph.new(args, &block)
      add(new_graph)

      @graph_label_count = 0 unless @graph_label_count

      dynamic_text(args.merge({:position => Vec2.new(20, 20 + 20 * @graph_label_count)})) do
        args[:label] + ': ' + sprintf(args[:label_format], new_graph.y_max)
      end

      dynamic_text(args.merge({:position => Vec2.new(20, screen_height - 20 - 20 * @graph_label_count)})) do
        args[:label] + ': ' + sprintf(args[:label_format], new_graph.y_min)
      end

      @graph_label_count += 1

      new_graph
    end

    def joystick(texture_name, args = {})
      texture = QGame::AssetManager.texture(texture_name)
      texture_base = "#{texture_name}_base"

      args = centered_args_from_texture(args)
      args[:screen_space] = true

      base_image = image(texture_base, args)
      new_joystick = QGame::VirtualThumbstick.new({:texture => texture, :radius => base_image.scale.x / 2.0}.merge(args))
      
      on_event(:mouse_up) do |event|
        new_joystick.handle_mouse_up(event)
      end

      on_event(:mouse_down) do |event|
        new_joystick.handle_mouse_down(event)
      end

      add(new_joystick)
      new_joystick
    end

    def apply_float(float_args, component)
      float_position = Vec2.new

      float_args = [float_args] unless float_args.is_a? Array
      float_args.each do |float_arg|
        case float_arg
        when :left
          float_position.x = component.size.x / 2.0
        when :right
          float_position.x = size.x - component.size.x
        when :top
          float_position.y = component.size.y
        when :bottom
          float_position.y = size.y - component.size.y
        when :middle_x
          float_position.x = size.x / 2.0 - component.size.x / 2.0
        when :middle_y
          float_position.y = size.y / 2.0 - component.size.y / 2.0
        when :middle
          float_position.x = size.x / 2.0 - component.size.x / 2.0
          float_position.y = size.y / 2.0 - component.size.y / 2.0
        end
      end

      component.position += float_position
      float_position
    end

    def stack_container(args = {}, &block)
      new_container = QGame::StackContainer.new(args, &block)
      add(new_container)

      new_container.build
      apply_float(args[:float], new_container)
      
      new_container
    end
  end
end
