module CrystalInsideFort
  module MODEL
    class RouteInfo
      property path, workers, controllerName
      @controllerName : String
      @path : String
      # @controllerId : Controller.class
      @shields : Array(Shield.class)

      # @values[]

      def initialize(controllerClass)
        @controllerName = controllerClass.name
        @path = ""
        @workers = {} of String => MODEL::WorkerInfo
        @shields = [] of Shield.class
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
