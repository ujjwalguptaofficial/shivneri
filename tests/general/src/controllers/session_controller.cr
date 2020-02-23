module General
  class SessionController < Controller
    @[Worker]
    def add
      key = self.body["key"].to_s
      value = self.body["value"]
      self.session[key] = value
      return text_result("saved")
    end

    @[Worker]
    @[Route("/add-many")]
    def add_many
      key1 = body["key1"]
      value1 = body["value1"]
      key2 = body["key2"]
      value2 = body["value2"]
      self.session.set_many({
        key1 => value1,
        key2 => value2,
      })
      return text_result("saved")
    end

    @[Worker]
    def exist
      key = self.query["key"]
      if (self.session.is_exist(key))
        return text_result("key is found")
      else
        return text_result("key is not found")
      end
    end

    @[Worker]
    def get
      key = self.query["key"]
      self.logger.debug("key", key)
      value_from_session = self.session[key]
      self.logger.debug("value from session", value_from_session)
      return json_result({
        value: value_from_session,
      })
    end

    @[Worker]
    def update
      key = self.body["key"]
      value = self.body["value"]
      self.session[key] = value
      return text_result("updated")
    end

    @[Worker]
    def remove
      key = self.query["key"]
      self.session.remove(key)
      return text_result("removed")
    end

    @[Worker]
    def clear
      self.session.clear
      return text_result("cleared")
    end

    @[Worker]
    def get_all
      value_from_session = self.session.get_all
      return json_result({
        value: value_from_session,
      })
    end
  end
end
