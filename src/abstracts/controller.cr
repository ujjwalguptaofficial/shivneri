# require "../handlers/index"
# require "../annotations/index"
require "json"

module CrystalInsideFort
  module Abstracts
    abstract class Controller
      # include Handlers
      # include Annotations
      property context
      @request : HTTP::Request | Nil = nil
      @response : HTTP::Server::Response | Nil = nil

      @context : RequestHandler | Nil = nil

      def json_result(value)
        result = HttpResult.new(value.to_json, MIME_TYPE["json"])
        return result
      end

      def query
        return @context.as(RequestHandler).query
      end
    end
  end
end
