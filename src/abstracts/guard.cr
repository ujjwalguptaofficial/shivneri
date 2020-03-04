module Shivneri
  module ABSTRACT
    abstract class Guard < BaseComponent
      def body
        return @context.as(RequestHandler).body
      end

      def param
        return @context.as(RequestHandler).route_match_info.params
      end

      # macro get_tuple_from_body(value)
      #   {{value}}.get_tuple_from_hash_json_any.call(@context.as(RequestHandler).body)
      # end

      abstract def check(*args)
    end
  end
end
