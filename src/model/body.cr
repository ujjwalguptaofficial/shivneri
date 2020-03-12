require "json"

module Shivneri
  module MODEL
    struct Body
      JSON.mapping(
        body_data: Hash(String, JSON::Any)
      )
      setter body_data

      @body_data : Hash(String, JSON::Any)

      def initialize(@body_data)
      end

      def to_tuple(value)
        return convert_to_tuple(value)
      end

      macro convert_to_tuple(value)
        return {{value}}.get_tuple_from_hash_json_any.call(@body_data)
      end

      def as_hash
        return @body_data
      end

      def [](key : String)
        return @body_data[key]
      end

      def []?(key : String)
        return @body_data[key]?
      end

      def []=(key : String, value)
        @body_data[key] = value
      end

      def merge(hash)
        @body_data.merge!(hash)
      end

      def has_key(key : String)
        @body_data.has_key?(key)
      end

      def has_key?(key : String)
        @body_data.has_key?(key)
      end

      #   def to_json
      #     return @body_data.to_json
      #   end

      #   def to_json(value : JSON::Builder)
      #     return @body_data.to_json
      #   end
    end
  end
end
