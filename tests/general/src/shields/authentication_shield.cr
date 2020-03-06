module General
  class AuthenticationShield < Shield
    @@counter = 0

    def protect
      @@counter = @@counter + 1
      puts "authentication shield executed"
      self["authentication_shield_counter"] = @@counter
      logger.debug("data", self.component_data)
      query = self.query
      data = self.component_data
      if (self.request.headers.has_key?("throw_exception_by_shield"))
        raise ("thrown by shield")
      end

      if self.session.is_exist("user_id")
        nil_result
      else
        if (worker_name == "allow_me")
          nil_result
        else
          redirect_result("/default/login")
        end
      end
    end
  end
end
