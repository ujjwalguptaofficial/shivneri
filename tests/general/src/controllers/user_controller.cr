module General
  # @[Shields(AuthenticationShield)]
  class UserController < Controller
    @[Worker("GET")]
    @[Route("/")]
    def get_users
      path_location = File.join(Dir.current, "contents/JsStore_16_16.png")
      return file_result(path_location)
    end

    @[Worker("POST")]
    @[Route("/")]
    @[Guards(UserValidator)]
    @[Inject(as_body(NamedTuple(name: String)))]
    def add_user(val : NamedTuple(name: String))
      return text_result("ok")
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
