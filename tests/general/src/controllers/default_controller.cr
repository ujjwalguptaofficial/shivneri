require "../../../../src/fort"
include CrystalInsideFort::Abstracts
include CrystalInsideFort::Annotations

module General
  @[DefaultWorker(2)]
  class DefaultController < Controller
    @store = {} of String => Proc(Nil);

    @[DefaultWorker(2)]
    def index
      puts "hey Ujjwal"
      return 0
    end

    @[Worker("GET", "POST")]
    def index1
      puts "hey Ujjwal"
    end

    @[Route("/index")]
    def index2
      puts "hey Ujjwal"
    end

    def bar
      {
        #  "ctrl":  ->{ method1 },
        "shift": ->{ index2 },
        #  "alt":   ->{ method3 },
      }
    end

    def add_proc
    end

    # def [](proc)
    #   puts typeof(proc)
    #   bar["shift"]
    #   # index2
    # end
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
