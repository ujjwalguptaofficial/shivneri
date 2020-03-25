module General
  class ChatController < WebSocketController
    def connected
      puts "Socket connected"
    end

    @[Worker]
    def receive_plain_message
      puts "receive message called"
      send("receive message calledjjwal")
    end

    def on_message(message : String)
      puts "message #{message}"
      send("Hey I am Ujjwal")
    end

    def disconnected
      puts "Socket disconnected"
    end
  end
end
