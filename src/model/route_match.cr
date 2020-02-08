module CrystalInsideFort
  module MODEL
    class RouteMatch
      property controllerInfo, workerInfo, params, allowedHttpMethod

      @controllerInfo : RouteInfo
      @workerInfo : WorkerInfo | Nil = nil
      @allowedHttpMethod : Array(String)
      @params : Hash(String, String | Int32)

      # JSON.mapping(
      #   params: Hash(String, String | Int32),
      #   allowedHttpMethod: Array(String)
      # )

      def initialize(controllerInfo)
        @controllerInfo = controllerInfo
        @allowedHttpMethod = [] of String
        @params = {} of String => String | Int32
        # @workerInfo = WorkerInfo.new("", [] of String, -> { 1 })
      end

      def to_json
        return {
          @allowedHttpMethod.to_json,
          @params.to_json,
        }
      end
    end
  end
end
