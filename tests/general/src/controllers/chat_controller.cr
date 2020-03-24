module General
  class ChatController < WebSocketController
    def connected
      puts "Socket connected"
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
