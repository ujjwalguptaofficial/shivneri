require "../../../../src/fort"
include CrystalInsideFort::ABSTRACT
include CrystalInsideFort::Annotations
require "../shields/authentication_shield"
require "../guards/test_guard"

module General
  @[Shields(AuthenticationShield)]
  class DefaultController < Controller
    @[DefaultWorker]
    @[Guards(TestGuard)]
    def index
      return view_result("default/index.html", {
        "title" => "Fort",
      })
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
