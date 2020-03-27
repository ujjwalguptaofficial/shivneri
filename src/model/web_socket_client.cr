module Shivneri
  module MODEL
    struct WebSocketClient
      # def initialize(&@emit_proc : ALIAS::MessagePayload ->)
      # end

      def initialize(@socket : HTTP::WebSocket)
      end

      private def send(message : ALIAS::MessagePayload)
        @socket.send(message.to_json)
      end

      def emit(event_name : String, data : String)
        puts "emit called #{data}"
        send({
          event_name: event_name,
          data:       data,
          data_type:  "string",
        })
      end

      def emit(event_name : String, data)
        send({
          event_name: event_name,
          data:       data.to_json,
          data_type:  "json",
        })
      end

      def emit(event_name : String, data : ALIAS::NumberType)
        send({
          event_name: event_name,
          data:       data.to_s,
          data_type:  "number",
        })
      end

      def emit(event_name : String, data : Bool)
        send({
          event_name: event_name,
          data:       data.to_s,
          data_type:  "bool",
        })
      end

      def close
        @socket.close
      end
    end
  end
end
