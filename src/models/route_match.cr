module CrystalInsideFort
  module Models
    class RouteMatch
      property controllerInfo, workerInfo, params, allowedHttpMethod

      @controllerInfo : RouteInfo
      @workerInfo : WorkerInfo
      @allowedHttpMethod : Array(String)
      @params : Hash(String, String | Int32)

      def initialize(controllerInfo)
        @controllerInfo = controllerInfo
        @allowedHttpMethod = [] of String
        @params = {} of String => String | Int32
        @workerInfo = WorkerInfo.new("", [] of String)
      end
    end
  end
end
