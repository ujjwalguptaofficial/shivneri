module General
  class ChatController < WebSocketController
    def connected
      puts "Socket connected"
    end

    @[Event]
    def receive_plain_message
      puts "receive message called"
      client.emit("receiveMessage", message.as_s)
      # send("message received is #{message.as_s}")
    end

    # def on_message(message : String)
    #   # puts "message #{message}"
    #   # send("Hey I am Ujjwal")
    # end

    def disconnected
      puts "Socket disconnected"
    end
  end
end
