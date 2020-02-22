module CrystalInsideFort
  module HELPER
    # @@fc = "as"

    def singleton(value)
      # if (InjectorHandler.store.has_key?(value) == false)
      #   InjectorHandler.store[value.name] = value.new
      # end
      # add_in_store(value, value.new)
      # return value.new
      ->{
        return value.new
      }
    end

    macro add_in_store(type, value)
    #   # @@\{{(type.id + "__").gsub(/:/, "_").underscore}} ||= \{{value}}.as(\{{type}})
      # @@fc = "as" #{{value}}
      # def asd
      # end
      class asdd
        
      end
    end
  end
end
