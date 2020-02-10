# require "../handlers/index"
# require "../annotations/index"
require "json"

module CrystalInsideFort
  module Abstracts
    abstract class Controller
      property context
      @request : HTTP::Request | Nil = nil
      @response : HTTP::Server::Response | Nil = nil

      @context : RequestHandler | Nil = nil

      def query
        return @context.as(RequestHandler).query
      end

      def body
        return @context.as(RequestHandler).body
      end

      def param
        return @context.as(RequestHandler).route_match_info.params
      end
    end
  end
end
