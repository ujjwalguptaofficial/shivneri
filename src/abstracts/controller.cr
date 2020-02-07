# require "../handlers/index"
# require "../annotations/index"

module CrystalInsideFort
  module Abstracts
    abstract class Controller
      # include Handlers
      # include Annotations
      property request, response, query
      @request : HTTP::Request | Nil = nil
      @response : HTTP::Server::Response | Nil = nil
      @query = {} of String => String | Int32

      macro method_added(method)
        {% puts "Method added:", method.name.stringify %}
      end

      macro finished
         {% puts "methods are", @type.methods.map &.name %}
      end
    end
  end
end
