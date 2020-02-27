require "../abstracts/shield"

# require "../hashes/index"

module Shivneri
  module GENERIC
    # include Abstracts

    # include HASHES

    class GenericShield < Shield
      def protect : HttpResult | Nil
        # response.headers.add("Wall-Without-Outgoing-Wall", "*"");
        return HttpResult.new("blocked by generic shield", "text/plain")
      end
    end
  end
end
