require "../abstracts/index"
require "../tuples/all"

module Shivneri
  module GENERIC
    include ABSTRACT
    include TUPLE

    class GenericController < Controller
      def generic_method
        text_result("")
      end
    end
  end
end
