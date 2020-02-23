module General
  class HomeController < Controller
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
