module Shivneri
  module MODEL
    alias WebSocketMap = Hash(String, WebSocketClient)

    class WebSocketClients
      getter groups

      # key is controller name
      @@socket_store = {} of String => WebSocketMap
      @socket_id : String
      @controller_name : String = ""
      @excepts : Array(String)

      def initialize(@controller_name : String, @excepts : Array(String))
        @socket_id = ""
        @groups = WebSocketGroups.new @controller_name, @excepts
      end

      def initialize(@socket_id : String, @controller_name : String)
        @groups = WebSocketGroups.new @socket_id
        @excepts = [] of String
      end

      def except_me
        return except([@socket_id])
      end

      def except(args : Array(String))
        WebSocketClients.new(@controller_name, args)
      end

      def current
        return @@socket_store[@controller_name][@socket_id]
      end

      def controller_name=(value)
        @controller_name = value
        # set controller name in group
        @groups.controller_name = value
      end

      def emit(event_name : String, data)
        if (@excepts.size > 0)
          @@socket_store[@controller_name].each do |id, socket|
            unless (@excepts.includes? id)
              socket.emit(event_name, data)
            end
          end
        else
          @@socket_store[@controller_name].each_value do |socket|
            socket.emit(event_name, data)
          end
        end
      end

      def emit_to(socket_id : String, event_name : String, data)
        @@socket_store[@controller_name][socket_id].emit(event_name, data)
      end

      # def self.emit_to(socket_id : String, event_name : String, data)
      #   @@socket_store[@controller_name][socket_id].emit(event_name, data)
      # end

      def add(socket)
        if (@@socket_store.has_key?(@controller_name))
          @@socket_store[@controller_name][@socket_id] = WebSocketClient.new socket
        else
          @@socket_store[@controller_name] = {
            @socket_id => WebSocketClient.new socket,
          }
        end
      end

      def delete
        @@socket_store[@controller_name].delete @socket_id
        @groups.remove_from_all @socket_id
      end
    end
  end
end
