module General
  class ChatController < WebSocketController
    def connected
      puts "Socket connected"
    end

    @[Event]
    def receive_string_message
      # puts "receive string called"
      clients.current.emit("receiveMessage", message.as_s)
    end

    @[Event]
    def receive_number_message
      clients.current.emit("receiveMessage", 12345)
    end

    @[Event]
    def receive_json_message
      clients.current.emit("receiveJsonMessage", message)
    end

    @[Event]
    def receive_bool_message
      clients.current.emit("receiveMessage", message.as_bool)
    end

    def disconnected
      puts "Socket disconnected"
    end
  end
end
