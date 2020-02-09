require "../handlers/index"
require "../annotations/index"

module CrystalInsideFort
  module Abstracts
    abstract class Wall
      include Handlers
      include Annotations

      property context
      @request : HTTP::Request | Nil = nil
      # @response : HTTP::Server::Response | Nil = nil

      @context : RequestHandler | Nil = nil

      abstract def on_incoming(*args) : HttpResult | Nil

      def on_outgoing(*args)
      end

      def response
        return @context.as(RequestHandler).response
      end

      def query
        return @context.as(RequestHandler).query
      end
    end
  end
end
