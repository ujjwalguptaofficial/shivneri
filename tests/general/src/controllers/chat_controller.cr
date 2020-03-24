module General
  class ChatController < WebSocketController
    def connected
      puts "Socket connected"
    end

    def disconnected
      puts "Socket disconnected"
    end
  end
end
