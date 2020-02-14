module General
  class AuthenticationShield < Shield
    def protect
      # text_result("blocked by shield")
      nil_result
    end
  end
end
