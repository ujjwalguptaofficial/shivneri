module Shivneri
  module MODEL
    struct WebSocketClients
      def initialize(@current_proc : Proc(WebSocketClient))
      end

      def current
        return @current_proc.call
      end

      def broadcast
      end
      
    end
  end
end
