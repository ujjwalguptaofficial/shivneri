require "../../../../src/fort"
include CrystalInsideFort::Abstracts
include CrystalInsideFort::Annotations

module General
  @[DefaultWorker(2)]
  class DefaultController < Controller
    @store = {} of String => Proc(Nil)
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
