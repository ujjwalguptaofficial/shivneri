module Shivneri
  module MODEL
    alias WebSocketMap = Hash(String, WebSocketClient)

    class WebSocketClients
      getter groups

      # key is controller name
      @@socket_store = {} of String => WebSocketMap
      @socket_id : String
      @controller_name : String = ""

      # def initialize(@current_proc : Proc(WebSocketClient))
      # end

      def initialize
        @socket_id = UUID.random.to_s
        @groups = WebSocketGroups.new ->{ @socket_id }
      end

      def initialize(@controller_name)
        initialize
      end

      def current
        return @@socket_store[@controller_name][@socket_id]
      end

      def emit(event_name : String, data)
        @@socket_store[@controller_name].each_value do |socket|
          socket.emit(event_name, data)
        end
      end

      def emit_to(socket_id : String, event_name : String, data)
        @@socket_store[@controller_name][socket_id].emit(event_name, data)
      end

      # def self.emit_to(socket_id : String, event_name : String, data)
      #   @@socket_store[@controller_name][socket_id].emit(event_name, data)
      # end

      def add(socket, controller_name)
        @controller_name = controller_name
        if (@@socket_store.has_key?(controller_name))
          @@socket_store[controller_name][@socket_id] = WebSocketClient.new socket
        else
          @@socket_store[controller_name] = {
            @socket_id => WebSocketClient.new socket,
          }
        end

        # set controller name in group
        @groups.controller_name = controller_name
      end

      def remove
        @@socket_store[@controller_name].delete @socket_id
        @groups.remove_from_all @socket_id
      end
    end
  end
end
