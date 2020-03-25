module General
  class WallWithoutOutgoing < Wall
    def incoming
      response.headers.add("Access-Control-Allow-Origin", "*")
      response.headers.add("custom-header-from-outgoing-wall", "*")
      return nil_result
    end
  end
end
