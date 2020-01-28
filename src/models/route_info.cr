module CrystalInsideFort
  module Models
    class RouteInfo
    

      @path : String

      # @shields
      # @values[]

      def initialize(controllerId)
        # @controllerId = controllerId
        @path = ""
        @workers = {} of String => Models::WorkerInfo
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

      #    def init(value : IRouteInfo)
      #         this.controllerName = value.controllerName;
      #         this.controller = value.controller;
      #         this.path = value.path;
      #         this.shields = value.shields;
      #         this.values = value.values;
      #         this.workers = value.workers;
      #     end
    end
  end
end
