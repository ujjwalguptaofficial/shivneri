require "./base_web_socket_controller"

# require "../annotations/index"

module Shivneri
  module ABSTRACT
    abstract class WebSocketController < BaseWebSocketController
      getter clients, ping_interval, ping_timeout

      # getter message

      # @message = JSON::Any.new(nil)

      def initialize
        @clients = WebSocketClients.new
      end

      private def on_ping_from_client
        clients.current.emit("pong", "pong")
      end

      private def add_socket(socket)
        @clients.add(
          socket,
          @context.as(RequestHandler).route_match_info.controller_name
        )
      end

      # def add_to(group_id : String)
      #   if (@@groups_as_string.has_key?(group_id) == false)
      #     @@groups_as_string[group_id] = [@@socket_id]
      #   else
      #     @@groups_as_string[group_id] = @socket_id
      #   end
      # end

      # def send_to(group_id : String, message : String)
      #   store = @@socket_store[@controller_name]
      #   @@groups_as_string[group_id].each do |socket_id|
      #     store[socket_id].send(message)
      #   end
      # end

      private def get_worker_procs
        {% begin %}
            {% klass = @type %}
             return NamedTuple.new(
                {% for method in klass.methods.select { |m| m.visibility == :public && m.annotation(Event) } %}
                  {% method_name = "#{method.name}" %}  
                  {% if method.args.size == 0 %}
                      raise "Invalid Event - event '{{method.name}}'  must have an argument."
                  {% end %}
                  {% first_arg_type = "#{method.args[0].restriction}" %}   
                  {{method_name}}: -> (instance : {{klass}},message : JSON::Any) {
                            puts {{method.args[0].restriction}}
                            {% if first_arg_type == "String" %}
                              instance.{{method.name}}(message.as_s)
                            {% else %}
                              instance.{{method.name}}(message)
                            {% end %}
                            nil
                        },
                  # args: {{method.args[0]}},
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

        web_socket_handler_instance = HTTP::WebSocketHandler.new do |socket|
          add_socket(socket)

          worker_procs = get_worker_procs

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
            send_error(exception.message.as(String))
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
