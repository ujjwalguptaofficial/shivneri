require "../../../../src/fort"
include CrystalInsideFort::Abstracts
include CrystalInsideFort::Annotations

module General
  @[DefaultWorker(2)]
  class DefaultController < Controller
    @[DefaultWorker(2)]
    def index
      puts "hey Ujjwal"
    end

    @[Worker("GET", "POST")]
    def index1
      puts "hey Ujjwal"
    end

    @[Route("/index")]
    def index2
      puts "hey Ujjwal"
    end
  end
end

def me
  {% for method, idx in General::DefaultController.methods.select { |m| m.annotation(DefaultWorker) } %}
  {% puts "'#{method.name}'" %}
  {% end %}
  # {% end %}

end

me()
# puts General::DefaultController.new.methods["index"]
# {{General::DefaultController.methods[1].name}}
