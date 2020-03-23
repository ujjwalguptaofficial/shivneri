require "./base_web_socket_controller"

module Shivneri
  module ABSTRACT
    abstract class WebSocketController < BaseWebSocketController
      #   @[DefaultWorker]
      def handle_request
        if (!(request.headers["Connection"]? == "Upgrade" && request.headers["Upgrade"]? == "websocket"))
          return text_result("Not a http end point", 400)
        end

        web_socket_handler_instance = HTTP::WebSocketHandler.new do |socket|
          self.connected
          puts "Socket opened"
          #   SOCKETS << socket
          socket.on_message do |message|
            SOCKETS.each { |socket| socket.send "Echo back from server: #{message}" }
          end
          socket.on_close do
            self.disconnected
            #     SOCKETS.delete(socket)
            puts "Socket closed"
          end
        end

        web_socket_handler_instance.call(context)
      end

      abstract def connected
      abstract def disconnected
    end
  end
end
