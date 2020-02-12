require "../handlers/index"
require "../annotations/index"

module CrystalInsideFort
  module ABSTRACT
    abstract class Guard
      include Handlers
      include Annotations

      @query = {} of String => String | Int32

      abstract def check(*args)
    end
  end
end
