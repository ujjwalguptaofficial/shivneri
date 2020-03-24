module Shivneri
  module MODEL
    struct RouteMatch
      property params, allowedHttpMethod, worker_info, shields
      getter controller_name
      # @controllerInfo : RouteInfo
      @worker_info : WorkerInfo | Nil = nil
      @allowedHttpMethod : Array(String)
      @params : Hash(String, String)
      @controller_name : String
      @shields : Array(String)

      # JSON.mapping(
      #   params: Hash(String, String | Int32),
      #   allowedHttpMethod: Array(String)
      # )

      def initialize(@controller_name, @shields)
        @allowedHttpMethod = [] of String
        @params = {} of String => String
        # @workerInfo = WorkerInfo.new("", [] of String, -> { 1 })
      end

      def to_json
        return {
          "allowed http methods": @allowedHttpMethod.to_json,
          "params":               @params.to_json,
        }
      end
    end
  end
end
