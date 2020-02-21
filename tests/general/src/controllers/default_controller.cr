require "../../../../src/fort"
include CrystalInsideFort::ABSTRACT
include CrystalInsideFort::ANNOTATION
require "../shields/authentication_shield"
require "../guards/test_guard"

module General
  @[Shields(AuthenticationShield)]
  class DefaultController < Controller
    @[DefaultWorker]
    @[Guards(TestGuard)]
    @[Inject("Welcome to fort")]
    def index(title : String)
      return view_result("default/index.html", {
        "title" => title,
      })
    end

    @[Worker]
    @[Guards(TestGuard)]
    @[Inject("Ujjwal", "Gupta")]
    def index1(first_name : String, last_name : String)
      return text_result("#{first_name}#{last_name}")
    end

    @[Worker("GET", "POST")]
    @[Route("/friends")]
    def get_friends
      friends = ["mohan", "sohan"]
      return json_result({
        friends: friends,
      })
    end

    # @[Worker("POST")]
    # def index1
    #   # return json_result({"name" => "ujjwal gupta"})
    #   return json_result(body)
    # end

    # @[Route("/index/{value}")]
    # @[Worker]
    # def index2
    #   json_result(param)
    # end
  end
end
