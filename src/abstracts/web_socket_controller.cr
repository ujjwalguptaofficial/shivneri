require "./base_web_socket_controller"

# require "../annotations/index"

module Shivneri
  module ABSTRACT
    alias WebSocketMap = Hash(String, HTTP::WebSocket)

    abstract class WebSocketController < BaseWebSocketController
      getter message, client, ping_interval, ping_timeout

      @message = JSON::Any.new(nil)
      @socket_id : String
      @controller_name : String = ""
      @@socket_store = {} of String => WebSocketMap
      @@groups_as_string = {} of String => Array(String)
      @ping_interval = 10
      @ping_timeout = 10

      @pong_timer : Concurrent::Future(Nil) = delay(0) { }

      def initialize
        @socket_id = UUID.random.to_s
        @client = WebSocketClient.new do |payload|
          send(payload)
        end
      end

      def send_ping_to_client
        delay(@ping_interval) do
          send({
            event_name: "ping",
            data:       "ping",
            data_type:  "string",
          })
          wait_for_pong
        end
      end

      def wait_for_pong
        @pong_timer = delay(@ping_timeout) do
          @@socket_store[@controller_name][@socket_id].close
          nil
        end
      end

      def on_ping_from_client
        send({
          event_name: "pong",
          data:       "pong",
          data_type:  "string",
        })
      end

      def on_pong_from_client
        @pong_timer.cancel
        send_ping_to_client
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

      private def send(message : ALIAS::MessagePayload)
        @@socket_store[@controller_name][@socket_id].send(message.to_json)
      end

      def get_worker_procs
        {% begin %}
            {% klass = @type %}
             return NamedTuple.new(
                {% for method in @type.methods.select { |m| m.visibility == :public && m.annotation(Event) } %}
                  {% method_name = "#{method.name}" %}  
                  {{method_name}}: -> (instance : {{klass}}) {
                            instance.{{method.name}}
                            nil
                        },
                {% end %}
              )
          {% end %}
      end

      def send_error(message : String)
        send({
          event_name: "error",
          data:       message,
          data_type:  "string",
        })
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
              target_event_name = json_message["eventName"].as_s
              if (worker_procs.has_key?(target_event_name))
                @message = json_message["data"]
                worker_procs[target_event_name].call(self)
              else
                case target_event_name
                when "ping"
                  on_ping_from_client()
                when "pong"
                  on_pong_from_client()
                else
                  send_error("Invalid event - event #{target_event_name} not found")
                end
              end
            rescue exception
              send_error(exception.message.as(String))
            end
          end

          socket.on_close do
            self.disconnected
          end
          self.connected
          # send_ping_to_client()
        end

        web_socket_handler_instance.call(@context.as(RequestHandler).context)
        is_request_processed = true
        return HttpResult.new("Connection Established for web socket", "text/plain")
      end

      def get_info
        return HttpResult.new("ok", "text/plain")
      end

      abstract def connected
      abstract def disconnected
    end
  end
end
