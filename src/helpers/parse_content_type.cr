require "uri"

module Shivneri
  module HELPER
    def parse_content_type(value : String)
      splitted_value = value.split(";")
      return splitted_value[0]
    end
  end
end
