module Shivneri
  module ABSTRACT
    abstract class Wall < BaseComponent
      abstract def incoming(*args) : HttpResult | Nil

      def outgoing(*args)
      end
    end
  end
end
