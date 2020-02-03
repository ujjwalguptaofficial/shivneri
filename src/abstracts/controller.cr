require "../handlers/index"
require "../annotations/index"

module CrystalInsideFort
  module Abstracts
    abstract class Controller
      include Handlers
      include Annotations

      @query = {} of String => String | Int32
    end
  end
end
