require "json"

module Shivneri
  module MODEL
    class HttpFile
      include JSON::Serializable
      getter field_name, original_file_name, path, headers, size

      # /**
      # * same as name - the field name for this file
      # */
      @field_name : String

      #    /**
      #     * the filename that the user reports for the file
      #     */
      @original_file_name : String

      #    /**
      #     * the absolute path of the uploaded file on disk
      #     */
      @path : String

      #    /**
      #     * the HTTP headers that were sent along with this file
      #     */
      @headers : HTTP::Headers

      #    /**
      #     * size of the file in bytes
      #     */
      @size : UInt64

      # def initialize(@field_name, @original_file_name, @path, @headers, @size)
      # end

      def initialize(form_part : HTTP::FormData::Part, @path)
        @field_name = form_part.name
        @original_file_name = form_part.filename.as(String)
        @headers = form_part.headers
        @size = form_part.size != nil ? form_part.size.as(UInt64) : 0.to_u64
      end
    end
  end
end
