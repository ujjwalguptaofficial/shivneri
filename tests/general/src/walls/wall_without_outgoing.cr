module General
  class WallWithoutOutgoing < Wall
    def on_incoming
      response.headers.add("custom-header-from-outgoing-wall", "*")
      # return HttpResult.new("blocked by wall", "text/plain")
      # return text_result("Blocked by wall")
      return nil_result
    end
  end
end
