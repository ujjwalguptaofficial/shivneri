require "./base_web_socket_controller"

# require "../annotations/index"

module Shivneri
  module ABSTRACT
    alias WebSocketMap = Hash(String, HTTP::WebSocket)

    abstract class WebSocketController < BaseWebSocketController
      #   @[ANNOTATION::DefaultWorker]
      @socket_id : String
      @controller_name : String = ""
      @@socket_store = {} of String => WebSocketMap

      def initialize
        @socket_id = UUID.random.to_s
      end

      def add_socket(socket)
        @controller_name = @context.as(RequestHandler).route_match_info.controller_name
        if (@@socket_store.has_key?(@controller_name))
          @@socket_store[@controller_name][@socket_id] = socket
        else
          @@socket_store[@controller_name] = {
            @socket_id => socket,
          }
        end
        self.connected
      end

      def on_message(message : String)
      end

      def send(message : String)
        @@socket_store[@controller_name][@socket_id].send(message)
      end

      def handle_request
        if (!(request.headers["Connection"]? == "Upgrade" && request.headers["Upgrade"]? == "websocket"))
          return HttpResult.new("Not a http end point", "text/plain", 400)
        end

        web_socket_handler_instance = HTTP::WebSocketHandler.new do |socket|
          add_socket(socket)
          socket.on_message do |message|
            on_message(message)
            # puts
            # socket.send "Echo back from server: #{message}"
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
