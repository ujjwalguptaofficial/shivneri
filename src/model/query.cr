require "json"

module Shivneri
  module MODEL
    struct Query
      include JSON::Serializable

      @[JSON::Field]
      query_data : Hash(String, String)

      setter query_data

      @query_data : Hash(String, String)

      def initialize(@query_data)
      end

      def to_tuple(value)
        return convert_to_tuple(value)
      end

      macro convert_to_tuple(value)
        return {{value}}.get_tuple_from_hash_string.call(@query_data)
      end

      def as_hash
        return @query_data
      end

      def [](key : String)
        return @query_data[key]
      end

      def []?(key : String)
        return @query_data[key]?
      end

      def []=(key : String, value)
        @query_data[key] = value
      end

      def merge(hash)
        @query_data.merge!(hash)
      end

      def has_key(key : String)
        @query_data.has_key?(key)
      end

      def has_key?(key : String)
        @query_data.has_key?(key)
      end

      #   def to_json
      #     return @query_data.to_json
      #   end

      #   def to_json(value : JSON::Builder)
      #     return @query_data.to_json
      #   end
    end
  end
end
