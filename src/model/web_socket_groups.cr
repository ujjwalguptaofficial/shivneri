module Shivneri
  module MODEL
    struct WebSocketGroups
      setter controller_name
      @@groups_as_string = {} of String => Array(String)
      @controller_name : String = ""

      def initialize(@current_proc : Proc(String))
      end

      def add(group_name : String)
        add(group_name, @current_proc.call)
      end

      def remove(group_name : String)
        remove(group_name, @current_proc.call)
      end

      def remove(group_name : String, socket_id : String)
        if (@@groups_as_string.has_key?(group_name))
          @@groups_as_string[group_name].delete(socket_id)
          if (@@groups_as_string[group_name].size == 0)
            @@groups_as_string.delete group_name
          end
        end
      end

      def remove_from_all(socket_id : String)
        @@groups_as_string.each_key do |group_name|
          remove(group_name, socket_id)
        end
      end

      def add(group_name : String, socket_id : String)
        if (@@groups_as_string.has_key?(group_name))
          @@groups_as_string[group_name].push(socket_id)
        else
          @@groups_as_string[group_name] = [socket_id]
        end
      end

      def emit(group_name : String, event_name : String, message)
        if (@@groups_as_string.has_key? group_name)
          puts "group name #{group_name}, controller '#{@controller_name}'"
          clients = WebSocketClients.new(@controller_name)
          @@groups_as_string[group_name].each do |socket_id|
            clients.emit_to(socket_id, event_name, message)
          end
        end
      end
    end
  end
end
