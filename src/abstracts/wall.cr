module Shivneri
  module ABSTRACT
    abstract class Wall < BaseComponent
      abstract def incoming : HttpResult | Nil

      def outgoing
      end
    end
  end
end
