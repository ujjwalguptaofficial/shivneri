module CrystalInsideFort
  module MODEL
    class HttpFile
      # /**
      # * same as name - the field name for this file
      # */
      @field_name : String = ""
      #    /**
      #     * the filename that the user reports for the file
      #     */
      @original_file_name : String = ""
      #    /**
      #     * the absolute path of the uploaded file on disk
      #     */
      @path : String = ""

      #    /**
      #     * the HTTP headers that were sent along with this file
      #     */
      @headers : HTTP::Headers = HTTP::Headers.new
      #    /**
      #     * size of the file in bytes
      #     */
      @size : Int64 = 0
      #   def initialize( )

      #   end
    end
  end
end
