require_relative "../ffi-gosu/lib/gosu"

ROOT_PATH = File.expand_path("..", __FILE__)

require_relative "lib/window"
require_relative "lib/notification"
require_relative "lib/notification_manager"

Window.new.show