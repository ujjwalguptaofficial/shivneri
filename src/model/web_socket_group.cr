module Shivneri
  module MODEL
    struct WebSocketGroups
      @@groups_as_string = {} of String => Array(String)

      def initialize(@current_proc : Proc(String))
      end

      def create(group_name : String)
        @@groups_as_string[group_name] = [] of String
      end

      def add(group_name : String)
        add(group_name, @current_proc.call)
      end

      def add(group_name : String, socket_id : String)
        if (@@groups_as_string.has_key?(group_name))
          @@groups_as_string[group_name].push(socket_id)
        else
          @@groups_as_string[group_name] = [socket_id]
        end
      end

      def emit(group_name : String, event_name : String, message)
        # clients = WebSocketClients.new
        WebSocketClients.new.select (@@groups_as_string[group_name]) do |client|
          client.emit(event_name, message)
        end
      end
    end
  end
end
