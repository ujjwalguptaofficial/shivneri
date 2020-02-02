require "../handlers/index"
require "../annotations/index"

module CrystalInsideFort
  module Abstracts
    abstract class Wall
      include Handlers
      include Annotations

      @query = {} of String => String | Int32

      abstract def onIncoming(*args)

      abstract def onOutgoing(*args)
    end
  end
end
