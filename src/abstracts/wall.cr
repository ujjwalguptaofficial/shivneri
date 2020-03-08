module Shivneri
  module ABSTRACT
    abstract class Wall < BaseComponent
      abstract def accepted(*args) : HttpResult | Nil

      def finished(*args)
      end
    end
  end
end
