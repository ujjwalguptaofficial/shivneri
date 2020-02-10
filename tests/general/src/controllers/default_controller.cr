require "../../../../src/fort"
include CrystalInsideFort::Abstracts
include CrystalInsideFort::Annotations
require "../shields/authentication_shield"

module General
  @[Shields(AuthenticationShield)]
  class DefaultController < Controller
    @[DefaultWorker(2)]
    def index
      # puts "hey Ujjwal"
      return json_result({name: "ujjwa", age: 25})
    end

    @[Worker("GET", "POST")]
    def index1
      # return json_result({"name" => "ujjwal gupta"})
      return json_result(body)
    end

    @[Route("/index/{value}")]
    @[Worker]
    def index2
      return json_result(param)
    end
  end
end
