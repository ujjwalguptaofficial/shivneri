require "../shields/authentication_shield"
require "../guards/test_guard"
require "../extras/my_singleton"

# include Shivneri::ABSTRACT
# include Shivneri::ANNOTATION

module General
  @[Inject("Welcome to fort")]
  class DefaultController < Controller
    def initialize(val : String)
    end

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
      sleep 5
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
  end
end
