# require "../handlers/index"
# require "../annotations/index"
require "json"

module CrystalInsideFort
  module Abstracts
    abstract class Controller
      # include Handlers
      # include Annotations
      property request, response, query
      @request : HTTP::Request | Nil = nil
      @response : HTTP::Server::Response | Nil = nil
      @query = {} of String => String | Int32

      def json_result(value)
        result = HttpResult.new(value.to_json, MIME_TYPE["json"])
        puts "result #{result}.to_json"
        return result
      end
    end
  end
end
