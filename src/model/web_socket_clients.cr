module Shivneri
  module MODEL
    struct WebSocketClients
      def initialize(@current_proc : Proc(WebSocketClient))
      end

      def current
        return @current_proc.call
      end

      def emit(event_name : String, data : String)
        current.emit(event_name, data)
      end

      def emit(event_name : String, data)
        current.emit(event_name, data)
      end

      def emit(event_name : String, data : ALIAS::NumberType)
        current.emit(event_name, data)
      end

      def emit(event_name : String, data : Bool)
        current.emit(event_name, data)
      end
    end
  end
end
