require "./base_web_socket_controller"

# require "../annotations/index"

module Shivneri
  module ABSTRACT
    alias WebSocketMap = Hash(String, HTTP::WebSocket)

    abstract class WebSocketController < BaseWebSocketController
      #   @[ANNOTATION::DefaultWorker]
      @message = JSON::Any.new(nil)
      @socket_id : String
      @controller_name : String = ""
      @@socket_store = {} of String => WebSocketMap
      @@groups_as_string = {} of String => Array(String)

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

      def add_to(group_id : String)
        if (@@groups_as_string.has_key?(group_id) == false)
          @@groups_as_string[group_id] = [@@socket_id]
        else
          @@groups_as_string[group_id] = @socket_id
        end
      end

      def send_to(group_id : String, message : String)
        store = @@socket_store[@controller_name]
        @@groups_as_string[group_id].each do |socket_id|
          store[socket_id].send(message)
        end
      end

      def on_message(message : String)
      end

      def send(message : String)
        @@socket_store[@controller_name][@socket_id].send(message)
      end

      def get_worker_procs
        {% begin %}
            {% klass = @type %}
             return NamedTuple.new(
                {% for method in @type.methods.select { |m| m.visibility == :public && m.annotation(Worker) } %}
                  {% method_name = "#{method.name}" %}  
                  {{method_name}}: -> (instance : {{klass}}) {
                            instance.{{method.name}}
                            nil
                        }
                {% end %}
              )
          {% end %}
      end

      def handle_request
        if (!(request.headers["Connection"]? == "Upgrade" && request.headers["Upgrade"]? == "websocket"))
          return HttpResult.new("Not a http end point", "text/plain", 400)
        end

        web_socket_handler_instance = HTTP::WebSocketHandler.new do |socket|
          add_socket(socket)
          worker_procs = get_worker_procs
          socket.on_message do |message|
            begin
              json_message = JSON.parse(message).as_h
              puts json_message
              target_worker_name = json_message["workerName"].as_s
              if (worker_procs.has_key?(target_worker_name))
                @message = json_message["data"]
                worker_procs[target_worker_name].call(self)
              else
                #   socket.send({

                # }.to_json)
              end
              on_message(message)
            rescue exception
              puts exception
            end

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

      def get_info
        return HttpResult.new({{@type}}.name, "text/plain")
      end

      abstract def connected
      abstract def disconnected
    end
  end
end
