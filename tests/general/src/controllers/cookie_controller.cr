module General
  class CookieController < Controller
    @[Worker("GET")]
    @[Route("/{cookie_name}")]
    def get_cookie
      cookie_name = param["cookie_name"].to_s
      if (cookie.is_exist(cookie_name))
        return json_result(cookie[cookie_name])
      else
        return text_result("cookie not found", 404)
      end
    end

    @[Worker("POST")]
    @[Route("/{cookie_name}")]
    def set_cookie
      puts "body is #{body.to_json}"
      cookie_name = param["cookie_name"]
      cookie_value = body["cookie_value"]
      cookie_obj = HttpCookie.new(cookie_name, cookie_value.to_s)
      cookie_obj.max_age = 5000
      cookie.add(cookie_obj)
      return json_result(cookie_obj)
    end

    @[Worker("PUT")]
    @[Route("/{cookie_name}")]
    def update_cookie
      puts "body update is #{body.to_json}"
      cookie_name = param["cookie_name"]
      cookie_value = body["cookie_value"]
      cookie_obj = HttpCookie.new(cookie_name.to_s, cookie_value.to_s)
      self.cookie.add(cookie_obj)
      return json_result(cookie_obj)
    end

    @[Worker("DELETE")]
    @[Route("/{cookie_name}")]
    def remove_cookie
      cookie_name = param["cookie_name"].to_s
      # puts "cookie_name #{cookie_name}"
      # puts "#{cookie.cookie_collection.to_json}"
      cookie.delete?(cookie_name)
      return text_result("deleted")
    end
  end
end
