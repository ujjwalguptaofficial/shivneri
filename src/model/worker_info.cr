module CrystalInsideFort
  module MODEL
    class WorkerInfo
      property pattern, methodsAllowed
      setter pattern : String
      @guards : Array(Guard.class)
      @workerProc : Proc(HttpResult)

      getter workerName : String

      getter workerProc : Proc(HttpResult)

      # values = [] of any;
      # expectedQuery?: any;
      # expectedBody?: any;

      def initialize(workerName : String, httpMethods : Array(String), @workerProc)
        @workerName = workerName
        @pattern = ""
        @methodsAllowed = httpMethods
        @guards = [] of Guard.class
      end
    end
  end
end
