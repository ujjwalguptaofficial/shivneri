module CrystalInsideFort
  module Helpers
    def removeLastSlash(value : String)
      valueLength = value.size
      # removing / from value;
      if (value[valueLength - 1] == "/")
        return value[0, valueLength - 1]
      end
      return value
    end
  end
end
