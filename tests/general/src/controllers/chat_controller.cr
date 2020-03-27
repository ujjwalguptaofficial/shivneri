module General
  class ChatController < WebSocketController
    def connected
      puts "Socket connected"
    end

    @[Event]
    def receive_string_message
      client.emit("receiveMessage", message.as_s)
    end

    @[Event]
    def send_number_message
      client.emit("receiveMessage", 12345)
    end

    @[Event]
    def send_json_message
      client.emit("receiveMessage", message)
    end

    @[Event]
    def receive_bool_message
      client.emit("receiveMessage", message.as_bool)
    end

    def disconnected
      puts "Socket disconnected"
    end
  end
end
