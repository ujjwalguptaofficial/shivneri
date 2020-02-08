require "../hashes/index"

module CrystalInsideFort
  module MODEL
    include HASHES

    class HttpResult
      property status_code, response_data, content_type
      @status_code : Int32 = 200
      @response_data : String
      @content_type : String
      # file?: FileResultInfo;
      @should_redirect : Bool = false

      def initialize(@response_data : String, @content_type : String)
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
