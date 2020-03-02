module General
  @[Inject("hello")]
  class UserValidator < Guard
    def initialize(value : String)
      @constructor_value = value
    end

    @[Inject("injection ok in guard")]
    def check(value : String)
      if (query["guard_injection_test"]? != nil)
        return text_result("#{@constructor_value} #{value}", 200)
      end

      err_message = validate
      return text_result(err_message, 400)
    end

    def validate
      if (body["name"]? == nil || body["name"].size < 5)
        return "name should be minimum 5 characters"
      elsif (body["password"]? == nil || body["password"].size < 5)
        return "password should be minimum 5 characters"
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
