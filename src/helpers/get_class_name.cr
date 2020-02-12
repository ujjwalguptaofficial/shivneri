require "json"

module CrystalInsideFort
  module HELPER
    def get_class_name(value : String)
      return value.split("::").last
    end
  end
end
