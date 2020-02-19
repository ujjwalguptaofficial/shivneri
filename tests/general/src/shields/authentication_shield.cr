module General
  class AuthenticationShield < Shield
    def protect
      puts "authentication shield executed"
      # return self.text_result("blocked by shield")
      # result = HttpResult.new("blocked by shield", MIME_TYPE["text"])
      # puts "returning result from authentication shield is #{result.to_json}"
      # return result
      # nil_result
    end
  end
end
