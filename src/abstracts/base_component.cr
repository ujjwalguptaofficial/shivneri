require "json"

module CrystalInsideFort
  module ABSTRACT
    class BaseComponent
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

      def json_result(value)
        result = HttpResult.new(value.to_json, MIME_TYPE["json"])
        @context.as(RequestHandler).result_channel.send(result)
      end

      def nil_result
        @context.as(RequestHandler).result_channel.send(nil)
      end

      def text_result(value : String)
        result = HttpResult.new(value, MIME_TYPE["text"])
        puts "returning text result"
        @context.as(RequestHandler).result_channel.send(result)
      end
    end
  end
end
