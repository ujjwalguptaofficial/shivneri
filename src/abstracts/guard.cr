require "../handlers/index"
require "../annotations/index"

module CrystalInsideFort
  module ABSTRACT
    abstract class Guard < BaseComponent
      # include Handlers
      # include Annotations

      abstract def check(*args)
    end
  end
end
