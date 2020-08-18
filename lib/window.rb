class Window < Gosu::Window
  TITLE = "Gosu Notification Test"
  def initialize
    super(1280, 800, false)

    @notification_manager = NotificationManager.new(edge: :right, window: self, max_visible: 3)
    @notification_manager_b = NotificationManager.new(edge: :top, mode: NotificationManager::MODE_CIRCLE, window: self)

    @notification_manager.create_notification(
      priority: Notification::PRIORITY_LOW,
      title: "Current Time [LOW]",
      tagline: "#{Time.now.strftime("%B %e, %Y %H:%M:%S %Z")}",
      icon: Notification::ICON_HOME,
    )
    @notification_manager.create_notification(
      priority: Notification::PRIORITY_HIGH,
      title: "Current Time [HIGH]",
      tagline: "#{Time.now.strftime("%B %e, %Y %H:%M:%S %Z")}",
      icon: Notification::ICON_WARNING,
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

    self.caption = "#{TITLE} [#{@notification_manager.notifications.count + @notification_manager_b.notifications.count} pending]"
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    super

    case id
    when Gosu::KB_ESCAPE
      @notification_manager.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "Escape Is Not Possible",
        tagline: "Trapped forever, you are.",
        icon: Notification::ICON_WARNING,
        icon_color: 0xaaffff00,
        time_to_live: Notification::TTL_SHORT,
        background_color: 0xaaaa4400,
        tagline_color: 0xaaeeeeee,
      )
    when Gosu::KB_SPACE
      @notification_manager.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "Jumping Is Not A Thing Here",
        tagline: "I... hmm.",
        icon: Notification::ICON_HOME,
        icon_color: 0xaa00ffff,
        time_to_live: Notification::TTL_SHORT
      )
    when Gosu::MS_LEFT
      @notification_manager_b.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "Mouse Mouse There's A Mouse!",
        tagline: "#{mouse_x}:#{mouse_y}",
        time_to_live: Notification::TTL_SHORT,
        icon: Notification::ICON_WARNING,
        title_color: 0xaaff0000,
        tagline_color: 0xaaff8844,
        icon_color: 0xaaff0000,
        edge_color: 0xaaff0000,
        background_color: 0xaa440000
      )
    when Gosu::MS_MIDDLE
      @notification_manager_b.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "Mouse Has Been Middled",
        tagline: "#{mouse_x}:#{mouse_y}",
        time_to_live: Notification::TTL_SHORT,
        tagline_color: 0xaa00ff00
      )
    when Gosu::MS_RIGHT
      @notification_manager_b.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "Mouse Has Been Dispatched",
        tagline: "404B: No cheese located at #{mouse_x}:#{mouse_y}",
        time_to_live: Notification::TTL_SHORT,
        edge_color: 0xaaffffff
      )
    end
  end

  def gamepad_connected(id)
    @notification_manager.create_notification(
      priority: Notification::PRIORITY_HIGH,
      title: "Gamepad Connected",
      tagline: "#{Gosu.gamepad_name(id)}",
      icon: Notification.const_get("ICON_GAMEPAD_#{id + 1}"),
      icon_color: 0xdd009922
    )
  end

  def gamepad_disconnected(id)
    @notification_manager_b.create_notification(
      priority: Notification::PRIORITY_HIGH,
      title: "Gamepad Disconnected",
      tagline: "#{Gosu.gamepad_name(id)}",
      icon: Notification.const_get("ICON_GAMEPAD_#{id + 1}"),
      icon_color: 0xdd990022
    )
  end
end