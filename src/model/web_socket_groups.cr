module Shivneri
  module MODEL
    struct WebSocketGroups
      setter controller_name
      # key is group name
      @@groups_as_string = {} of String => WebSocketGroup
      @controller_name : String = ""

      def initialize(@current_proc : Proc(String))
      end

      def delete(group_name : String)
        delete(group_name, @current_proc.call)
      end

      def delete(group_name : String, socket_id : String)
        if (@@groups_as_string.has_key?(group_name))
          @@groups_as_string[group_name].delete(socket_id)
          if (@@groups_as_string[group_name].size == 0)
            @@groups_as_string.delete group_name
          end
        end
      end

      def remove_from_all(socket_id : String)
        @@groups_as_string.each_key do |group_name|
          delete(group_name, socket_id)
        end
      end

      def add(group_name : String)
        add(group_name, @current_proc.call)
      end

      def add(group_name : String, socket_id : String)
        unless @@groups_as_string.has_key?(group_name)
          @@groups_as_string[group_name] = WebSocketGroup.new(@controller_name)
        end
        @@groups_as_string[group_name].add(socket_id)
      end

      def [](group_name : String)
        return @@groups_as_string[group_name]
      end

      def []?(group_name : String)
        if (@@groups_as_string.has_key? group_name)
          return @@groups_as_string[group_name]
        end
        return nil
      end

      def except(group_name : String, socket_ids : Array(String))
        group = WebSocketGroup.new(@controller_name, @@groups_as_string[group_name].socket_ids.clone)
        socket_ids.each do |socket_id|
          group.delete socket_id
        end
        return group
      end

      def except_me(group_name : String)
        except(group_name, [@current_proc.call])
      end
    end
  end
end
