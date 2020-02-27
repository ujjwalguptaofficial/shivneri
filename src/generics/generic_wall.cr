require "../abstracts/wall"

# require "../hashes/index"

module Shivneri
  module GENERIC
    # include Abstracts

    # include HASHES

    class GenericWall < Wall
      def on_incoming : HttpResult | Nil
        # response.headers.add("Wall-Without-Outgoing-Wall", "*"");
        return HttpResult.new("blocked by generic wall", "text/plain")
      end
    end
  end
end
