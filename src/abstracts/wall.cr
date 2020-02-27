module Shivneri
  module ABSTRACT
    abstract class Wall < BaseComponent
      abstract def on_incoming(*args) : HttpResult | Nil

      def on_outgoing(*args)
      end
    end
  end
end
