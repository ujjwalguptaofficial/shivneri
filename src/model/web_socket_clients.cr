module Shivneri
  module MODEL
    alias WebSocketMap = Hash(String, WebSocketClient)

    struct WebSocketGroups
      @@groups_as_string = {} of String => Array(String)

      def initialize(@current_proc : Proc(String))
      end

      def create(group_name : String)
        @@groups_as_string[group_name] = [] of String
      end

      def add(group_name : String)
        add(group_name, @current_proc.call)
      end

      def add(group_name : String, socket_id : String)
        if (@@groups_as_string.has_key?(group_name))
          @@groups_as_string[group_name].push(socket_id)
        else
          @@groups_as_string[group_name] = [socket_id]
        end
      end

      def emit(group_name : String, message)
      end
    end

    struct WebSocketClients
      @@socket_store = {} of String => WebSocketMap
      @socket_id : String
      @controller_name : String = ""

      # def initialize(@current_proc : Proc(WebSocketClient))
      # end

      def filters(socket_ids : Array(String))
        
      end

      def initialize
        @socket_id = UUID.random.to_s
        @groups = WebSocketGroups.new ->{ @socket_id }
      end

      def current
        return @@socket_store[@controller_name][@socket_id]
      end

      def emit(event_name : String, data)
        @@socket_store[controller_name].each_value do |socket|
          socket.emit(event_name, data)
        end
      end

      def add(socket, controller_name)
        @controller_name = controller_name
        if (@@socket_store.has_key?(controller_name))
          @@socket_store[controller_name][@socket_id] = WebSocketClient.new socket
        else
          @@socket_store[controller_name] = {
            @socket_id => WebSocketClient.new socket,
          }
        end
      end
    end
  end
end
