require "../services/user_service"

module General
  # Include SERVICE
  class HomeController < Controller
    def initialize
      @user_service = SERVICE::UserService.new
    end

    @[Worker("POST")]
    def login
      email_id = body["email"].to_s
      pwd = body["password"].to_s
      if (email_id != nil && pwd != nil)
        users = @user_service.get_user_by_email(email_id)
        if (users.size > 0)
          user = users[0]
          if (user != nil && user.password == pwd)
            self.session.set("user_id", user.id)
            self.session.set("email_id", JSON::Any.new(email_id))
            return text_result(`Authenticated`)
          else
            result = text_result("Invalid credential")
            return result
          end
        end
      end
      return text_result("Invalid credential")
    end

    @[Worker("GET")]
    @[Route("/login")]
    def get_login_form
      view_result("home/login_form.html")
    end

    @[Worker]
    def html
      html_result("<h1>hey there i am html</h1>")
    end

    @[Worker]
    def post
      json_result(body)
    end

    @[Worker]
    def redirect
      redirect_result("html")
    end
  end
end
