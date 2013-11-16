module TestGame
  class GameCamera < QGame::LookAtCamera
    def initialize(args = {})
      @follow = args[:follow]
      @offset_direction = args[:offset_direction] || Vec3.new(1)
      @offset_magnitude = args[:offset_magnitude] || 20

      super(args)

      QGame::Input.on(:camera_zoom) do |zoom_event|
        handle_zoom_change(zoom_event.mouse_wheel_y)
        zoom_event.handled = true
      end
    end

    def handle_zoom_change(zoom_delta)
      @offset_magnitude += zoom_delta
      @offset_magnitude = @offset_magnitude.clamp(5..40)
    end

    def update_position(position)
      @target = position
      @position = @target + (@offset_direction * @offset_magnitude)
    end

    def update
      update_position(@follow.position)

      super
    end
  end
end
