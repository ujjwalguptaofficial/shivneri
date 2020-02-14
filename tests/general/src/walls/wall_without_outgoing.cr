module General
  class WallWithoutOutgoing < Wall
    def on_incoming
      response.headers.add("Wall-Without-Outgoing-Wall", "*")
      # return HttpResult.new("blocked", "text/plain")
      nil_result
    end
  end
end
