require "../hashes/index"

module CrystalInsideFort
  module MODEL
    include HASHES

    class HttpResult
      property status_code, response_data, content_type, response_format, should_redirect
      @status_code : Int32
      @response_data : String
      @content_type : String
      # file?: FileResultInfo;
      @should_redirect : Bool = false

      @response_format : Nil | Hash(String, String) = nil

      def initialize(@response_data : String, @content_type : String, @status_code : Int32 = 200)
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
