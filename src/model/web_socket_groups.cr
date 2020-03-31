module Shivneri
  module MODEL
    alias WebSocketGroupMap = Hash(String, WebSocketGroup)

    struct WebSocketGroups
      setter controller_name
      # key is group name
      @@group_store = {} of String => WebSocketGroupMap
      @controller_name : String
      @active_socket_id : String
      @black_list_ids : Array(String)

      def initialize(@active_socket_id : String)
        @black_list_ids = [] of String
        @controller_name = ""
      end

      def initialize(@controller_name : String, @black_list_ids : Array(String))
        @active_socket_id = ""
      end

      def delete(group_name : String)
        delete(group_name, @active_socket_id)
      end

      def delete(group_name : String, socket_id : String)
        if (exist(group_name))
          @@group_store[@controller_name][group_name].delete(socket_id)
          if (@@group_store[@controller_name][group_name].size == 0)
            @@group_store[@controller_name].delete group_name
          end
        end
        nil
      end

      def remove_from_all(socket_id : String)
        @@group_store[@controller_name].each_key do |group_name|
          delete(group_name, socket_id)
        end
      end

      def add(group_name : String)
        add(group_name, @active_socket_id)
      end

      def add(group_name : String, socket_id : String)
        unless @@group_store.has_key?(@controller_name)
          @@group_store = {
            @controller_name => {} of String => WebSocketGroup,
          }
        end
        unless @@group_store[@controller_name].has_key?(group_name)
          @@group_store[@controller_name][group_name] = WebSocketGroup.new(@controller_name)
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
        return @black_list_ids.size > 0 ? get_group_with_except(group_name) : @@group_store[@controller_name][group_name]
      end

      def []?(group_name : String)
        if (exist group_name)
          return [group_name]
        end
        return nil
      end

      def get_group_with_except(group_name)
        group = WebSocketGroup.new(@controller_name, @@group_store[@controller_name][group_name].socket_ids.clone)
        @black_list_ids.each do |socket_id|
          group.delete socket_id
        end
        return group
      end
    end
  end
end
