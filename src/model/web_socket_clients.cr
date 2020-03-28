module Shivneri
  module MODEL
    alias WebSocketMap = Hash(String, WebSocketClient)

    class WebSocketClients
      getter groups

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

      # def select(socket_ids : Array(String), &block : WebSocketClient ->)
      #   puts "controller_name #{@controller_name}"
      #   puts "size #{@@socket_store[@controller_name].size} socket_ids #{socket_ids}"
      #   @@socket_store[@controller_name].each do |socket_id, client|
      #     # if (socket_ids.includes?(socket_id))
      #     #   # block.call client
      #     # end
      #   end
      # end

      # def select( socket_ids : Array(String))

      #   @@socket_store[@controller_name].each do |socket_id, client|
      #     # if (socket_ids.includes?(socket_id))
      #     #   # block.call client
      #     # end
      #   end
      # end

      # def select(&block : String -> Bool)
      #   clients = [] of WebSocketClient
      #   @@socket_store[@controller_name].each do |socket_id, client|
      #     if (block.call(socket_id))
      #       clients.push(client)
      #     end
      #   end
      #   return clients
      # end

      def current
        return @@socket_store[@controller_name][@socket_id]
      end

      def emit(event_name : String, data)
        @@socket_store[@controller_name].each_value do |socket|
          socket.emit(event_name, data)
        end
      end

      def emit_to(socket_id : String, event_name : String, data)
        puts "socket_id #{socket_id}, event_name #{event_name}, data #{data}"
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
