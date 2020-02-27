require "json"

module Shivneri
  module HELPER
    def json_result(value)
      result = HttpResult.new(value.to_json, MIME_TYPE["json"])
      return result
    end
  end
end
