module Shivneri
  module MODEL
    struct ViewReadOption
      getter file_location
      @file_location : String

      # map_view: Proc(viewData : String)

      def initialize(@file_location)
      end
    end
  end
end
