require "../handlers/index"
require "../annotations/index"

module CrystalInsideFort
  module Abstracts
    abstract class Shield
      include Handlers
      include Annotations

      @query = {} of String => String | Int32

      abstract def protect(*args)
    end
  end
end
