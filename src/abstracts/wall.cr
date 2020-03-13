module Shivneri
  module ABSTRACT
    abstract class Wall < BaseComponent
      abstract def entered(*args) : HttpResult | Nil

      def exited(*args)
      end
    end
  end
end
