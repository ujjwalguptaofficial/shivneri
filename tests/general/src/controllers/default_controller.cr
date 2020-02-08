require "../../../../src/fort"
include CrystalInsideFort::Abstracts
include CrystalInsideFort::Annotations

module General
  @[DefaultWorker(2)]
  class DefaultController < Controller
    @store = {} of String => Proc(Nil)
    @[DefaultWorker(2)]
    def index
      puts "hey Ujjwal"
      return json_result({name: "ujjwa", age: 25})
    end

    @[Worker("GET", "POST")]
    def index1
      # return json_result({"name" => "ujjwal gupta"})
      return json_result(query)
    end

    @[Route("/index")]
    def index2
      puts "hey Ujjwal"
    end
  end
end
