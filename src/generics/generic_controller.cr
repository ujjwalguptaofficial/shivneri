require "../abstracts/index"
require "../hashes/index"

module Shivneri
  module GENERIC
    include ABSTRACT
    include HASHES

    class GenericController < Controller
      def generic_method
        text_result("")
      end
    end
  end
end
