module General
  class InvalidInjectionGuard < Guard
    def check
      if (query["guard_injection_test"] != nil)
        return text_result("", 200)
      end
    end
  end
end
