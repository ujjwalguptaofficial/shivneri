module CrystalInsideFort
  module Models
    class RouteMatch
      property controller, workerInfo, params, shields, allowedHttpMethod, controllerName
      @controllerInfo : RouteInfo
      @workerInfo : WorkerInfo
      @allowedHttpMethod : Array(String)
      @params : Hash(String, String | Int32)

      def initialize(@controllerInfo)
        @allowedHttpMethod = [] of String
        @params = {} of String => String | Int32
        @workerInfo = WorkerInfo.new("", [] of String)
      end
    end
  end
end
