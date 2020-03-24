require "./base_web_socket_controller"

# require "../annotations/index"

module Shivneri
  module ABSTRACT
    abstract class WebSocketController < BaseWebSocketController
      #   @[ANNOTATION::DefaultWorker]
      def handle_request
        if (!(request.headers["Connection"]? == "Upgrade" && request.headers["Upgrade"]? == "websocket"))
          return HttpResult.new("Not a http end point", "text/plain", 400)
        end

        web_socket_handler_instance = HTTP::WebSocketHandler.new do |socket|
          self.connected
          puts "Socket opened"
          #   SOCKETS << socket
          socket.on_message do |message|
            # puts
            socket.send "Echo back from server: #{message}"
            # SOCKETS.each { |socket| socket.send "Echo back from server: #{message}" }
          end
          socket.on_close do
            self.disconnected
            #     SOCKETS.delete(socket)
            puts "Socket closed"
          end
        end

        web_socket_handler_instance.call(@context.as(RequestHandler).context)
        is_request_processed = true
        return HttpResult.new("Connection Established for web socket", "text/plain")
      end

      abstract def connected
      abstract def disconnected
    end
  end
end
