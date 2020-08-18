class NotificationManager
  attr_reader :edge
  def initialize(edge: :right, window:)
    @edge = edge
    @window = window

    @notifications = []
    @current_notification = nil

    @driver = nil
  end

  def draw
    if @driver
      # (@window.width + Notification::WIDTH)
      x = @edge == :right ? @window.width + @driver.x : -Notification::WIDTH + @driver.x
      Gosu.translate(x, @driver.y + Notification::HEIGHT / 2) do
        @current_notification&.draw
      end
    end
  end

  def update
    show_next_notification unless @current_notification
    show_next_notification if @driver && @driver.done?

    @driver&.update
  end

  def show_next_notification
    @driver = nil
    @current_notification = @notifications.shift

    return unless @current_notification

    @driver = Driver.new(edge: @edge, notification: @current_notification)
  end

  def push(notification)
    @notifications << notification
  end

  class Driver
    attr_reader :x, :y
    def initialize(edge:, notification:)
      @edge = edge
      @notification = notification

      @x, @y = 0, 0
      @delta = Gosu.milliseconds
      @accumulator = 0.0

      @born_at = Gosu.milliseconds
      @expired_at = Float::INFINITY
      @transition_completed_at = Float::INFINITY
    end

    def animation_complete?
      Gosu.milliseconds - @born_at >= @notification.animation_duration
    end

    def expired?
      Gosu.milliseconds - @transition_completed_at >= @notification.time_to_live
    end

    def done?
      Gosu.milliseconds - @expired_at >= @notification.animation_duration
    end

    def update
      if not animation_complete? # Slide In
        @x = @edge == :right ? -x_offset : x_offset
      elsif animation_complete? and not expired?
        @x = @edge == :right ? -Notification::WIDTH : Notification::WIDTH if @x.abs != Notification::WIDTH
        @transition_completed_at = Gosu.milliseconds if @transition_completed_at == Float::INFINITY
        @accumulator = 0.0
      elsif expired? # Slide Out
        @x = @edge == :right ? x_offset - Notification::WIDTH : Notification::WIDTH - x_offset
        @x = 0 if @edge == :left and @x <= 0
        @x = 0 if @edge == :right and @x >= 0
        @expired_at = Gosu.milliseconds if @expired_at == Float::INFINITY
      end

      @accumulator += Gosu.milliseconds - @delta
      @delta = Gosu.milliseconds
    end

    def x_offset
      if not animation_complete? or expired?
        Notification::WIDTH * (@accumulator / @notification.animation_duration)
      else
        0
      end
    end
  end
end