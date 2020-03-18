module Shivneri
  module ABSTRACT
    abstract class Guard < BaseComponent
      def body
        return @context.as(RequestHandler).body
      end

      def param
        return @context.as(RequestHandler).route_match_info.params
      end

      def file
        return @context.as(RequestHandler).file
      end

      abstract def check(*args)
    end
  end
end
