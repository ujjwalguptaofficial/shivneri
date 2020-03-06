require "../services/index"

module General
  include SERVICE
  @[Shields(AuthenticationShield)]
  @[Inject(instance(UserService))]
  class UserController < Controller
    def initialize(@service : UserService)
    end

    @[Worker("GET")]
    @[Route("/")]
    def get_users
      # path_location = File.join(Dir.current, "contents/JsStore_16_16.png")
      # return file_result(path_location)
      return json_result(@service.get_users)
    end

    @[Worker("GET")]
    @[Route("/count")]
    def get_user_count
      return text_result(@service.get_users.size)
    end

    @[Worker("GET")]
    @[Route("/{user_id}")]
    def get_user
      user_id = param["user_id"].to_i
      return json_result(@service.get_user_by_id(user_id))
    end

    @[Worker("GET")]
    @[Route("/shield/count")]
    def get_shield_count
      return text_result(self["authentication_shield_counter"])
    end

    @[Worker("POST")]
    @[Route("/")]
    @[Guards(UserValidator)]
    @[Inject("as_body")]
    @[ExpectBody(NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String))]
    def add_user(user)
      # user = body.to_tuple(NamedTuple(id: Int32, name: String)) # get_tuple_from_body(NamedTuple(id: Int32, name: String))
      # puts user
      # puts typeof(user)
      # puts user.to_json

      user = @service.add_user(MODEL::User.new(user))
      return json_result(user, 201)
    end

    @[Worker("PUT")]
    @[Route("/")]
    @[Guards(UserValidator)]
    def update_user
      user = body.to_tuple(NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String)) # get_tuple_from_body(NamedTuple(id: Int32, name: String))
      if (@service.update_user(MODEL::User.new(user)))
        return text_result("user updated")
      else
        return text_result("invalid user")
      end
      return json_result(user, 200)
    end

    @[Worker("DELETE")]
    @[Route("/{user_id}")]
    def delete_user
      user_id = param["user_id"].to_i
      if (@service.delete_user(user_id))
        return text_result("user deleted")
      else
        return text_result("invalid user")
      end
      return json_result(user, 200)
    end

    @[Worker("GET")]
    @[Route("/allow/me")]
    def allow_me
      text_result("i am allowed")
    end

    #   @[Worker]
    #   def post
    #     json_result(body)
    #   end

    #   @[Worker]
    #   def redirect
    #     redirect_result("html")
    #   end
  end
end
