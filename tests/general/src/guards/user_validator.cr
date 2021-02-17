module General
  @[Inject("injection ok in guard")]

  class UserValidator < Guard
    @user : NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String)

    def initialize(value : String)
      @constructor_value = value
      @user = body.to_tuple(NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String))
    end

    # @[ExpectBody(NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String))]
    # @[ExpectBody(User)]
    def check
      self.logger.debug "'#{query["guard_injection_test"]?}'"
      if (query["guard_injection_test"]? != nil)
        return text_result("#{@constructor_value}", 200)
      end
      if (request.headers.has_key?("guard_injection_test_return_body"))
        return json_result(@user, 200)
      end
      err_message = validate @user
      if (err_message.size > 0)
        return text_result(err_message, 400)
      end
      # return text_result("okkk")
    end

    def validate(user1)
      user = body.to_tuple(
        NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String)
      )
      # user = body.to_tuple(NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String))
      if (user[:name].size < 5)
        return "name should be minimum 5 characters"
      elsif (user[:password].size < 5)
        return "password should be minimum 5 characters"
      elsif (!["male", "female"].includes? user[:gender])
        return "gender should be either male or female"
      elsif (!user[:email][/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i])
        return "email not valid"
      elsif (user[:address].size < 10 || user[:address].size > 100)
        return "address length should be between 10 & 100"
      end
      return ""
    end
  end
end
