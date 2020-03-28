module General
  class ChatController < WebSocketController
    def connected
      puts "Socket connected"
    end

    @[Event]
    def join_room(room_name : String)
      # puts "receive string called"
      clients.groups.add(room_name)
      clients.current.emit("receiveMessage", "Welcome to group #{room_name}")
      # clients.groups[room_name].emit("groupMessage", "New member has joined")
      puts "size before except me #{clients.groups[room_name].size}"
      clients.groups.except_me(room_name).emit("groupMessage", "New member has joined")
      puts "size #{clients.groups[room_name].size}"
    end

    @[Event]
    def receive_message_from_group(message : NamedTuple(group_name: String, data: String))
      clients.groups[message[:group_name]].emit("groupMessage", message[:data])
    end

    @[Event]
    def receive_string_message(message : String)
      # puts "receive string called"
      clients.current.emit("receiveMessage", message)
    end

    @[Event]
    def receive_number_message(message)
      clients.current.emit("receiveMessage", 12345)
    end

    @[Event]
    def receive_json_message(message)
      clients.current.emit("receiveJsonMessage", message)
    end

    @[Event]
    def receive_bool_message(message)
      clients.current.emit("receiveMessage", message.as_bool)
    end

    def disconnected
      puts "Socket disconnected"
    end
  end
end
