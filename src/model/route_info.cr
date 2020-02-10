module CrystalInsideFort
  module MODEL
    class RouteInfo
      property path, workers, controllerName, shields
      @controllerName : String
      @path : String
      # @controllerId : Controller.class
      @shields = [] of Proc(RequestHandler, HttpResult | Nil)

      # @values[]

      def initialize(controllerClass)
        @controllerName = controllerClass.name
        @path = ""
        @workers = {} of String => MODEL::WorkerInfo
      end

      def workers_as_array
        workersArray = [] of WorkerInfo
        h.each_key do |key|
          workersArray.push(workers[key]) # => "foo"
        end
        return workersArray
      end

      def to_json
        return {
          "controller Name": @controllerName,
          "path":            @path,
          "workers":         @workers,
        }
      end
    end
  end
end
