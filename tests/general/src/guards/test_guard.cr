module General
  class TestGuard < Guard
    def check
      # text_result("blocked by guard")
        nil_result
    end
  end
end
