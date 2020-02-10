module General
  class AuthenticationShield < Shield
    

    def protect
      response.headers.add("Wall-Without-Outgoing-Wall", "*")
      # return HttpResult.new("blocked", "text/plain")
      return nil
    end
  end
end
