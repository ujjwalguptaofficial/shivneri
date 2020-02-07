module CrystalInsideFort
  module MODEL
    class HttpCookie
      @name : String
      @value : String

      # @maxAge : Int32
      # @expires : Time
      # @domain : String
      # @http_only : Bool
      # @secure : Bool
      # @path : String

      def initialize(@name : String, @value : String)
        # @name = name
        # @value = value
      end
    end
  end
end
