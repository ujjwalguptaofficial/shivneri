module CrystalInsideFort
  module Abstracts
    abstract class Shield
      property context
      @request : HTTP::Request | Nil = nil
      @response : HTTP::Server::Response | Nil = nil

      @context : RequestHandler | Nil = nil

      def request
        return @context.as(RequestHandler).request
      end

      def response
        return @context.as(RequestHandler).response
      end

      def query
        return @context.as(RequestHandler).query
      end

      abstract def protect(*args) : HttpResult | Nil
    end
  end
end
