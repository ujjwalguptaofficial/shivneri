module Shivneri
  module MODEL
    alias WebSocketMap = Hash(String, WebSocketClient)

   

    struct WebSocketClients
      @@socket_store = {} of String => WebSocketMap
      @socket_id : String
      @controller_name : String = ""

      # def initialize(@current_proc : Proc(WebSocketClient))
      # end

      def select(socket_ids : Array(String), &block : WebSocketClient ->)
        @@socket_store[@controller_name].each do |socket_id, client|
          if (socket_ids.include?)
            block.call client
          end
        end
      end

      def select(&block : String -> Bool)
        clients = [] of WebSocketClient
        @@socket_store[@controller_name].each do |socket_id, client|
          if (block.call(socket_id))
            clients.push(client)
          end
        end
        return clients
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
