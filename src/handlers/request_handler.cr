require "http"

module CrystalInsideFort
  module Handlers
    class RequestHandler
      property request

      @request : HTTP::Request
      @response : HTTP::Server::Response

      def initialize(request : HTTP::Request, response : HTTP::Server::Response)
        @request = request
        @response = response
      end

      def handle
        execute
      end

      def execute
        requestMethod = @request.method
        pathUrl = @request.path
        routeMatchInfo_ = parseRoute(pathUrl.downcase, requestMethod)
      end
    end
  end
end
