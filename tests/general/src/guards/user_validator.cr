module General
  @[Inject("hello")]
  class UserValidator < Guard
    # @user : NamedTuple(id: Int32, name: String)

    def initialize(value : String)
      @constructor_value = value
    end

    @[Inject("injection ok in guard", "as_body")]
    # @[ExpectBody(body_of("UserController", "as"))]
    @[BodyOf("UserController", "add_user")]
    # @[ExpectBody(NamedTuple(id: Int32, name: String))]
    def check(value : String, user)
      # puts "user in guard"
      # puts user
      if (query["guard_injection_test"]? != nil)
        return text_result("#{@constructor_value} #{value}", 200)
      end

      # err_message = validate
      # if (err_message.size > 0)
      #   return text_result(err_message, 400)
      # end
      # return text_result("okkk")
    end

    def validate
      # user = get_tuple_from_body(
      #   NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String)
      # )
      user = body.to_tuple(NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String))
      if (user[:name].size < 5)
        return "name should be minimum 5 characters"
      elsif (user[:password].size < 5)
        return "password should be minimum 5 characters"
      elsif (["male", "female"].includes? user[:gender])
        return "gender should be either male or female"
        # elsif (/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match user[:email] == nil)
        #   return "email not valid"
      elsif (user[:address].size < 10 || user[:address].size > 10)
        return "address length should be between 10 & 100"
      end
      return ""

      # let errMessage;
      # if (user.name == null || !isLength(user.name, 5)) {
      #     errMessage = "name should be minimum 5 characters"
      # } else if (user.password == null || !isLength(user.password, 5)) {
      #     errMessage = "password should be minimum 5 characters";
      # } else if (user.gender == null || !isIn(user.gender, ["male", "female"])) {
      #     errMessage = "gender should be either male or female";
      # } else if (user.emailId == null || !isEmail(user.emailId)) {
      #     errMessage = "email not valid";
      # } else if (user.address == null || !isLength(user.address, 10, 100)) {
      #     errMessage = "address length should be between 10 & 100";
      # }
    end
  end
end
