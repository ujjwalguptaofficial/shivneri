module Shivneri
  module MODEL
    alias WebSocketGroupMap = Hash(String, WebSocketGroup)

    struct WebSocketGroups
      setter controller_name
      # key is group name
      @@group_store = {} of String => WebSocketGroupMap
      @controller_name : String = ""

      def initialize(@current_proc : Proc(String))
      end

      def delete(group_name : String)
        delete(group_name, @current_proc.call)
      end

      def delete(group_name : String, socket_id : String)
        if (@@group_store.has_key?(group_name))
          @@group_store[group_name].delete(socket_id)
          if (@@group_store[group_name].size == 0)
            @@group_store.delete group_name
          end
        end
      end

      def remove_from_all(socket_id : String)
        @@group_store.each_key do |group_name|
          delete(group_name, socket_id)
        end
      end

      def add(group_name : String)
        add(group_name, @current_proc.call)
      end

      def add(group_name : String, socket_id : String)
        unless @@group_store.has_key?(@controller_name)
          @@group_store = {
            @controller_name => {
              group_name => WebSocketGroup.new(@controller_name),
            },
          }
        end
        @@group_store[@controller_name][group_name].add(socket_id)
      end

      def exist(group_name : String)
        @@group_store.has_key?(@controller_name) && @@group_store[@controller_name].has_key? group_name
      end

      def exist(group_name : String, socket_id : String)
        exist(group_name) && @@group_store[@controller_name][group_name].exist socket_id
      end

      def [](group_name : String)
        return @@group_store[@controller_name][group_name]
      end

      def []?(group_name : String)
        if (exist group_name)
          return [group_name]
        end
        return nil
      end

      def except(group_name : String, socket_ids : Array(String))
        group = WebSocketGroup.new(@controller_name, @@group_store[@controller_name][group_name].socket_ids.clone)
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
