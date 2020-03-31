module General
  class ChatController < Shivneri::WebSocketController
    @groups = [] of String

    def connected
      clients.current.emit("receiveMessage", "You are connected")
      puts "Socket connected"
    end

    @[On("join-room")]
    def join_room(room_name : String)
      if clients.groups.exist(room_name, socket_id)
        return
      end
      # puts "receive string called"
      clients.groups.add(room_name)
      clients.current.emit("receiveMessage", "Welcome to group #{room_name}")
      # clients.groups[room_name].emit("groupMessage", "New member has joined")
      puts "size before except me #{clients.groups[room_name].size}"
      clients.groups.except_me(room_name).emit("groupMessage", "New member has joined")
      puts "size #{clients.groups[room_name].size}"
      @groups.push room_name
    end

    @[On]
    def receive_message_from_group(message : NamedTuple(group_name: String, data: String))
      clients.groups[message[:group_name]].emit("groupMessage", message[:data])
    end

    @[On]
    def receive_string_message(message : String)
      # puts "receive string called"
      clients.current.emit("receiveMessage", message)
    end

    @[On]
    def receive_number_message(message)
      clients.current.emit("receiveMessage", message)
    end

    @[On]
    def receive_json_message(message)
      clients.current.emit("receiveMessage", message)
    end

    @[On]
    def receive_bool_message(message)
      clients.current.emit("receiveMessage", message.as_bool)
    end

    def disconnected
      puts "Socket disconnected"
      @groups.each do |value|
        clients.groups[value].emit("groupMessage", "someone left")
      end
    end
  end
end
