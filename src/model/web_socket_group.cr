module Shivneri
  module MODEL
    struct WebSocketGroup
      setter controller_name
      @socket_ids = [] of String
      @controller_name : String = ""

      def initialize(@controller_name : String)
        
      end

      def add(socket_id : String)
        @socket_ids.push(socket_id)
      end

      def delete(socket_id : String)
        @socket_ids.delete(socket_id)
      end

      def size
        return @socket_ids.size
      end

      def emit(event_name : String, message)
        clients = WebSocketClients.new(@controller_name)
        @socket_ids.each do |socket_id|
          clients.emit_to(socket_id, event_name, message)
        end
      end
    end
  end
end
