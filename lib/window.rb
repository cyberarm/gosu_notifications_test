class Window < Gosu::Window
  TITLE = "Gosu Notification Test"
  def initialize
    super(1280, 800, false)
    self.caption = TITLE

    @notification_manager = NotificationManager.new(edge: :left, window: self)
    @notification_manager_b = NotificationManager.new(edge: :right, window: self)

    @notification_manager.push(
      Notification.new(
        host: @notification_manager,
        priority: 0.0,
        title: "Current Time",
        tagline: "#{Time.now.strftime("%B %e, %Y %H:%M:%S %Z")}",
        icon: Notification::ICON_HOME,
      )
    )
  end

  def draw
    Gosu.draw_rect(0, 0, width, height, 0xff884412)

    Notification::TITLE_FONT.draw_text(TITLE, width / 2 - Notification::TITLE_FONT.text_width(TITLE) / 2, height / 2 - Notification::TITLE_FONT.height / 2, 0, 1, 1, Gosu::Color::WHITE, :add)

    @notification_manager.draw
    @notification_manager_b.draw
  end

  def update
    @notification_manager.update
    @notification_manager_b.update
  end

  def needs_cursor?
    true
  end

  def gamepad_connected(id)
    @notification_manager.push(
      Notification.new(
        host: @notification_manager,
        priority: 1.0,
        title: "Gamepad Connected",
        tagline: "#{Gosu.gamepad_name(id)}",
        icon: Notification.const_get("ICON_GAMEPAD_#{id + 1}"),
        icon_color: 0xdd009922
      )
    )
  end

  def gamepad_disconnected(id)
    @notification_manager_b.push(
      Notification.new(
        host: @notification_manager_b,
        priority: 1.0,
        title: "Gamepad Disconnected",
        tagline: "#{Gosu.gamepad_name(id)}",
        icon: Notification.const_get("ICON_GAMEPAD_#{id + 1}"),
        icon_color: 0xdd990022
      )
    )
  end
end