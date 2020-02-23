module CrystalInsideFort
  module MODEL
    class HttpCookie
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
    end
  end
end
