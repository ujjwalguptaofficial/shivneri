require "json"

module Shivneri
  module MODEL
    class HttpCookie
      include JSON::Serializable
      property name, value, expires, http_only, max_age, path, domain

      @name : String
      @value : String

      @max_age : Int32 = FortGlobal.session_timeout * 60
      @expires : Time
      @domain : String | Nil = nil
      @http_only : Bool
      # @secure : Bool
      @path : String

      def initialize(@name, @value, @http_only, @path, @expires)
      end

      def initialize(@name, @value, @http_only, @path)
        now = Time.utc
        @expires = now + FortGlobal.session_timeout.minutes
      end

      def initialize(@name, @value)
        @http_only = false
        @path = "/"
        now = Time.utc
        @expires = now + FortGlobal.session_timeout.minutes
      end
    end
  end
end
