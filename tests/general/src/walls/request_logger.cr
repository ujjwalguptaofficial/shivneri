module General
  @[Inject("wall constructor")]
  class RequestLogger < Wall
    def initialize(value : String)
      @injection_value = value
    end

    @@req_count = 0

    private def get_ip
      ip = (request.headers["x-forwarded-for"]? || "").split(",").pop || request.remote_address
      return ip
    end

    def incoming
      if (query["req_count_reset"]? != nil)
        @@req_count = 0
      end
      response.headers["Custom-Header-From-Incoming-Wall"] = "1"
      self["ip"] = get_ip
      # if (this.query.doNotCount !== 'true') {
      self["req_count"] = @@req_count += 1
      # }

      if (request.headers["block_by_wall"]? != nil || query["blockByWall"]? == "true")
        return text_result("blocked by wall")
      elsif (request.headers["throw_exception"]? != nil)
        raise "thrown by wall"
      end
      #   response.headers.add("custom-header-from-outgoing-wall", "*")
      #   return nil_result
    end

    def outgoing
      logger.debug("executing request logger")
      response.headers["Custom-Header-From-Outgoing-Wall"] = "*"
      response.headers["injection-result"] = @injection_value
      response.headers["request_count_from_wall"] = @@req_count.to_s
    end
  end
end
