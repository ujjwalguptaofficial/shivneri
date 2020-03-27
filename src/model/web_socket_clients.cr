module Shivneri
  module MODEL
    alias WebSocketMap = Hash(String, WebSocketClient)

    struct WebSocketClients
      @@socket_store = {} of String => WebSocketMap
      @@groups_as_string = {} of String => Array(String)
      @socket_id : String
      @controller_name : String = ""

      # def initialize(@current_proc : Proc(WebSocketClient))
      # end

      def initialize
        @socket_id = UUID.random.to_s
      end

      def current
        return @@socket_store[@controller_name][@socket_id]
      end

      def create_group(group_name : String)
        @@groups_as_string[group_name] = [] of String
      end

      # def add_to(group_name : String, socket_id : String)

      # end

      # def emit_to(group_name : String)
      # end

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
