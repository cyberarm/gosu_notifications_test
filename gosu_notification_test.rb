begin
  require_relative "../ffi-gosu/lib/gosu"
rescue LoadError => e
  puts "Something when wrong loading ffi-gosu:"
  puts e.message
  puts e.backtrace

  require "gosu"
end

ROOT_PATH = File.expand_path("..", __FILE__)

require_relative "lib/window"
require_relative "lib/notification"
require_relative "lib/notification_manager"

Window.new.show