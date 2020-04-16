require "../tuples/all"

module Shivneri
  module MODEL
    include TUPLE

    struct HttpResult
      property status_code, response_data, content_type, response_format, should_redirect, file
      @status_code : Int32
      @response_data : String
      @content_type : String
      @file : FileResultInfo | Nil = nil
      @should_redirect : Bool = false

      @response_format : Nil | Hash(String, String)

      def initialize(@response_data : String, @content_type : String, @status_code : Int32 = 200)
        @response_format = nil
      end

      def initialize(@response_data : String, @content_type : String, @should_redirect)
        @status_code = 302
        @response_format = nil
      end

      def initialize(@response_format : Hash(String, String), @status_code : Int32 = 200)
        @response_data = ""
        @content_type = ""
      end

      def to_json
        return {
          "status Code":   @status_code,
          "response_data": @response_data,
          "content_type":  @content_type,
        }
      end
    end
  end
end
