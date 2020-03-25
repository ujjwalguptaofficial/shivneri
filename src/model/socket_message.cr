require "json"

module Shivneri
  module MODEL
    struct SocketMessage
      JSON.mapping(
        message: JSON::Any
      )
      setter message

      @message : JSON::Any

      def initialize(@message)
      end

      def to_tuple(value)
        return convert_to_tuple(value)
      end

      macro convert_to_tuple(value)
        return {{value}}.get_tuple_from_hash_json_any.call(@message)
      end

      def as_hash
        return @message
      end

      def [](key : String)
        return @message[key]
      end

      def []?(key : String)
        return @message[key]?
      end

      def []=(key : String, value)
        @message[key] = value
      end

      def merge(hash)
        @message.merge!(hash)
      end

      def has_key(key : String)
        @message.has_key?(key)
      end

      def has_key?(key : String)
        @message.has_key?(key)
      end
    end
  end
end
