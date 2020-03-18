require "./base_component"

module Shivneri
  module ABSTRACT
    abstract class Controller < BaseComponent
      def body
        return @context.as(RequestHandler).body
      end

      def param
        return @context.as(RequestHandler).route_match_info.params
      end

      def file
        return @context.as(RequestHandler).file
      end
    end
  end
end
