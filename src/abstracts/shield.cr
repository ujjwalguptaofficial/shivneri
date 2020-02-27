module Shivneri
  module ABSTRACT
    abstract class Shield < BaseComponent
      abstract def protect(*args) : HttpResult | Nil
    end
  end
end
