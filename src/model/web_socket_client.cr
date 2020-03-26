module Shivneri
  module MODEL
    struct WebSocketClient
      def initialize(&@emit_proc : ALIAS::MessagePayload ->)
      end

      def emit(event_name : String, data : String)
        @emit_proc.call({
          event_name: event_name,
          data:       data,
          data_type:  "string",
        })
      end

      def emit_json(event_name : String, data)
        @emit_proc.call({
          event_name: event_name,
          data:       data.to_json,
          data_type:  "json",
        })
      end

      def emit(event_name : String, data : ALIAS::NumberType)
        @emit_proc.call({
          event_name: event_name,
          data:       data.to_s,
          data_type:  "number",
        })
      end

      def emit(event_name : String, data : Bool)
        @emit_proc.call({
          event_name: event_name,
          data:       data.to_s,
          data_type:  "bool",
        })
      end
    end
  end
end
