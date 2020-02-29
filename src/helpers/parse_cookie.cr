require "uri"

module Shivneri
  module HELPER
    def parse_cookie(cookie : String) : Hash(String, String)
      value = {} of String => String
      if (!cookie.blank?)
        cookie.split(";").each do |val|
          parts = val.split("=")
          value[parts.shift.strip] = URI.decode(parts.join('='))
        end
      end
      return value
    end
  end
end
