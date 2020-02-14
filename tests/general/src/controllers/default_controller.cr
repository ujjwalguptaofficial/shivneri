require "../../../../src/fort"
include CrystalInsideFort::ABSTRACT
include CrystalInsideFort::Annotations
require "../shields/authentication_shield"

module General
  @[Shields(AuthenticationShield)]
  class DefaultController < Controller
    @[DefaultWorker]
    def index
      puts "hey Ujjwal"
      # return json_result({name: "ujjwa", age: 25})
      return text_result("ujjwal")
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
