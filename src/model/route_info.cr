module CrystalInsideFort
  module MODEL
    class RouteInfo
      property path, workers, controllerId, controllerName
      @controllerName : String
      @path : String
      @controllerId : Controller.class
      @shields : Array(Shield.class)

      # @values[]

      def initialize(controllerClass)
        @controllerName = controllerClass.name
        @controllerId = controllerClass
        # @controllerId.new
        @path = ""
        @workers = {} of String => MODEL::WorkerInfo
        @shields = [] of Shield.class
      end

      def workersAsArray
        # return Object.keys(this.workers).map(workerName => {
        #     return this.workers[workerName];
        #     return this.workers[workerName];
        # });
        workersArray = [] of WorkerInfo
        h.each_key do |key|
          workersArray.push(workers[key]) # => "foo"
        end
        return workersArray
      end

      def to_json
        return {
          @controllerName,
          @path,
          @workers
        }
      end
    end
  end
end
