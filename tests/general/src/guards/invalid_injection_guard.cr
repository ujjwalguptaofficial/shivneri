module General
  class InvalidInjectionGuard < Guard
    def check(value : String)
      if (query["guard_injection_test"] != nil)
        return text_result("#{@constructor_value} #{value}", 200)
      end
    end
  end
end
