require "./base_web_socket_controller"

# require "../annotations/index"

module Shivneri
  module ABSTRACT
    abstract class WebSocketController < BaseWebSocketController
      getter clients, ping_interval, ping_timeout, socket_id

      @socket_id : String

      def initialize
        @socket_id = UUID.random.to_s
        @clients = WebSocketClients.new @socket_id, ""
      end

      private def on_ping_from_client
        clients.current.emit("pong", "pong")
      end

      private def add_socket(socket)
        @clients.controller_name = @context.as(RequestHandler).route_match_info.controller_name
        @clients.add(
          socket
        )
      end

      private def get_worker_procs
        {% begin %}
            {% klass = @type %}
             return NamedTuple.new(
                {% for method in klass.methods.select { |m| m.visibility == :public && m.annotation(On) } %}
                  {% method_name = "#{method.name}" %}  
                  {% if method.args.size == 0 %}
                      raise "Invalid event subscriber - event subscriber '{{method.name}}'  must have an argument."
                  {% end %}
                  {% first_arg_type = "#{method.args[0].restriction}" %}
                  {% on_annotation = method.annotation(On) %}
                  {{ on_annotation && on_annotation.args.size > 0 ? on_annotation.args[0] : method_name }}: -> (instance : {{klass}},message : JSON::Any) {
                      {% if first_arg_type == "String" %}
                        instance.{{method.name}}(message.as_s)
                      {% elsif first_arg_type.includes?("NamedTuple") %}
                        instance.{{method.name}}({{method.args[0].restriction}}.get_tuple_from_hash_json_any.call(message.as_h))
                      {% else %}
                        instance.{{method.name}}(message)
                      {% end %}
                      nil
                  },
                {% end %}
              )
          {% end %}
      end

      private def send_error(message : String)
        clients.current.emit("error", message)
      end

      def handle_request
        if (!(request.headers["Connection"]? == "Upgrade" && request.headers["Upgrade"]? == "websocket"))
          return HttpResult.new("Not a http end point", "text/plain", 400)
        end

        worker_procs = get_worker_procs
        web_socket_handler_instance = HTTP::WebSocketHandler.new do |socket|
          add_socket(socket)

          socket.on_message do |message|
            json_message = JSON.parse(message).as_h
            target_event_name = json_message["eventName"].as_s
            if (worker_procs.has_key?(target_event_name))
              # @message = json_message["data"]
              worker_procs[target_event_name].call(self, json_message["data"])
            else
              case target_event_name
              when "ping"
                on_ping_from_client()
                # when "pong"
                #   on_pong_from_client()
              else
                send_error("Invalid event - event #{target_event_name} not found")
              end
            end
          rescue exception
            send_error (on_error(exception))
          end

          socket.on_close do
            clients.delete
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

      def connected
        puts "Socket connected"
      end

      def disconnected
        puts "Socket disconnected"
      end

      def on_error(exception)
        return {
          message:    exception.message.as(String),
          stacktrace: exception.callstack.as(CallStack).printable_backtrace,
        }.to_json
      end
    end
  end
end
