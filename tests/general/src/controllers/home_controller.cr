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
            self.session["user_id"] = user.id
            self.session["email_id"] = email_id
            return text_result("Authenticated")
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

    @[Worker("GET")]
    def text
      text_result("text")
    end

    @[Worker]
    def json
      json_result({key: "hello", value: "world"})
    end

    @[Worker]
    def html
      html_result("<h1>hey there i am html</h1>")
    end

    @[Worker("POST")]
    def post
      json_result(body)
    end

    @[Worker]
    def redirect
      redirect_result("html")
    end

    @[Worker]
    def get_data
      json_result(self.component_data)
    end

    @[Worker]
    def log_out
      session.clear
      return text_result("Logged out")
    end

    @[Worker]
    def get_env
      return text_result(ENV["CRYSTAL_ENV"])
    end

    @[Worker]
    def get_users
      return json_result(@user_service.get_users)
    end

    # @[Worker]
    # def get_students()
    #     return jsonResult(self.studentService.getAll());
    # end

    # @Worker()
    # async getEmployees() {
    #     return jsonResult(this.employeeService.getAll());
    # }

    # @Worker()
    # async getAllFromServices(@Singleton(UserService) userService,
    #     @Singleton(StudentService) studentService,
    #     @Singleton(EmployeeService) employeeService) {
    #     return jsonResult([...studentService.getAll(), ...employeeService.getAll(),
    #     ...userService.getUsers()]);
    # }
  end
end
