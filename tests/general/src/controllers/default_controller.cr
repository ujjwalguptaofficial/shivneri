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
      # return view_result("default/index.html", {
      #   "title" => "Fort",
      # })
      # return text_result("index")
      return text_result(title)
    end

    @[Worker("POST")]
    def index1
      # return json_result({"name" => "ujjwal gupta"})
      return json_result(body)
    end

    @[Route("/index/{value}")]
    @[Worker]
    def index2
      json_result(param)
    end
  end
end
