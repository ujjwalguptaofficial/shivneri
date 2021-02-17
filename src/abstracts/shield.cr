module Shivneri
  module ABSTRACT
    abstract class Shield < BaseComponent
      abstract def protect : HttpResult | Nil
    end
  end
end
