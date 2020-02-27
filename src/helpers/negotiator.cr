require "json"

module Shivneri
  module HELPER
    class Negotiator
      def media_type(available : Array(String))
        return self.media_type("*/*", available)
      end

      def media_type(accept_header : String, available : Array(String))
        comma_splitted = accept_header.split(",")
        mime_type_store = [] of NamedTuple(mime_type: String, weight: Float64)
        comma_splitted.each do |mime_type|
          semi_colon_splits = mime_type.split(";")
          type = semi_colon_splits[0].strip
          if (semi_colon_splits.size == 1)
            index = available.index(type)
            if (index != nil)
              return available[index.as(Int32)]
            end
            mime_type_store.push({
              mime_type: type,
              weight:    1.0,
            })
          else
            mime_type_store.push({
              mime_type: type,
              weight:    semi_colon_splits.last.strip.split("=").last.to_f,
            })
          end
        end
        mime_type_store.sort! { |x, y| y[:weight] <=> x[:weight] }
        mime_type_store.each do |mime_type_with_weight|
          if (mime_type_with_weight[:mime_type] == "*/*")
            return available[0]
          end
          index = available.index { |type| mime_type_with_weight[:mime_type] == type }
          if (index != nil)
            return available[index.as(Int32)]
          end
        end
      end
    end
  end
end
