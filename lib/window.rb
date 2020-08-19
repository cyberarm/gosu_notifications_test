class Window < Gosu::Window
  TITLE = "Gosu Notification Test"
  def initialize
    super(1280, 800, false)

    @notification_manager_a = NotificationManager.new(edge: :left,   mode: NotificationManager::MODE_DEFAULT, window: self, max_visible: 5)
    @notification_manager_b = NotificationManager.new(edge: :right,  mode: NotificationManager::MODE_CIRCLE,  window: self, max_visible: 1)
    @notification_manager_c = NotificationManager.new(edge: :top,    mode: NotificationManager::MODE_DEFAULT, window: self, max_visible: 3)
    @notification_manager_d = NotificationManager.new(edge: :bottom, mode: NotificationManager::MODE_CIRCLE,  window: self, max_visible: 2)

    @sum = 0
  end

  def draw
    Gosu.draw_rect(0, 0, width, height, 0xff884412)

    string = "#{TITLE} [#{@sum} pending]"

    Notification::TITLE_FONT.draw_text(string, width / 2 - Notification::TITLE_FONT.text_width(string) / 2, height / 2 - Notification::TITLE_FONT.height / 2, 0, 1, 1, Gosu::Color::WHITE, :add)

    @notification_manager_a.draw
    @notification_manager_b.draw
    @notification_manager_c.draw
    @notification_manager_d.draw
  end

  def update
    @notification_manager_a.update
    @notification_manager_b.update
    @notification_manager_c.update
    @notification_manager_d.update

    @sum = @notification_manager_a.notifications.count +
          @notification_manager_b.notifications.count +
          @notification_manager_c.notifications.count +
          @notification_manager_d.notifications.count

    self.caption = "#{TITLE} [#{@sum} pending]"
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    super

    case id
    when Gosu::KB_ESCAPE
      @notification_manager_a.create_notification(
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
      @notification_manager_b.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "Jumping Is Not A Thing Here",
        tagline: "I... hmm.",
        icon: Notification::ICON_HOME,
        icon_color: 0xaa00ffff,
        time_to_live: Notification::TTL_SHORT
      )
    when Gosu::MS_LEFT
      @notification_manager_c.create_notification(
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
      @notification_manager_c.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "Mouse Has Been Middled",
        tagline: "#{mouse_x}:#{mouse_y}",
        time_to_live: Notification::TTL_SHORT,
        tagline_color: 0xaa00ff00
      )
    when Gosu::MS_RIGHT
      @notification_manager_c.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "Mouse Has Been Dispatched",
        tagline: "404B: No cheese located at #{mouse_x}:#{mouse_y}",
        time_to_live: Notification::TTL_SHORT,
        edge_color: 0xaaffffff
      )
    when Gosu::KB_LEFT_CONTROL
      @notification_manager_d.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "I Will Control... Something!",
        time_to_live: Notification::TTL_SHORT,
        transition_duration: 1000.0,
        title_color: 0xaaff8800,
        edge_color: 0xaaff8800,
      )
    when Gosu::KB_RIGHT_CONTROL
      @notification_manager_d.create_notification(
        priority: Notification::PRIORITY_LOW,
        title: "I Will Control... Something Else!",
        time_to_live: Notification::TTL_SHORT,
        transition_duration: 1000.0,
        title_color: 0xaa88ff00,
        edge_color: 0xaaffffaa,
      )
    end
  end

  def gamepad_connected(id)
    @notification_manager_c.create_notification(
      priority: Notification::PRIORITY_HIGH,
      title: "Gamepad Connected",
      tagline: "#{Gosu.gamepad_name(id)}",
      icon: Notification.const_get("ICON_GAMEPAD_#{id + 1}"),
      icon_color: 0xdd009922
    )
  end

  def gamepad_disconnected(id)
    @notification_manager_c.create_notification(
      priority: Notification::PRIORITY_HIGH,
      title: "Gamepad Disconnected",
      tagline: "#{Gosu.gamepad_name(id)}",
      icon: Notification.const_get("ICON_GAMEPAD_#{id + 1}"),
      icon_color: 0xdd990022
    )
  end
end