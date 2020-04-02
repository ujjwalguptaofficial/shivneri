module Shivneri
  module HELPER
    def remove_first_slash(value : String)
      # removing first / from value;
      if (value[0] == '/')
        return value[1, value.size]
      end
      return value
    end
  end
end
