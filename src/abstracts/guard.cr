module Shivneri
  module ABSTRACT
    abstract class Guard < BaseComponent
      abstract def check(*args)
    end
  end
end
