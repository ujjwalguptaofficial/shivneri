module CrystalInsideFort
  module MODEL
    class WorkerInfo
      property pattern, methodsAllowed
      @pattern : String

      @guards : Array(Guard.class)
      @workerProc : Proc(HttpResult)

      getter name : String

      getter workerProc : Proc(RequestHandler, HttpResult)

      # values = [] of any;
      # expectedQuery?: any;
      # expectedBody?: any;

      def initialize(workerName : String, httpMethods : Array(String), @workerProc)
        @name = workerName
        @pattern = "/#{workerName}"
        @methodsAllowed = httpMethods
        @guards = [] of Guard.class
      end

      def to_json
        return {
          @name,
          @pattern,
          @methodsAllowed.to_json,
        }
      end
    end
  end
end
