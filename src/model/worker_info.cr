module CrystalInsideFort
  module MODEL
    class WorkerInfo
      property pattern, methodsAllowed
      setter pattern : String
      @guards : Array(Shield.class)

      # values = [] of any;
      # expectedQuery?: any;
      # expectedBody?: any;

      def initialize(workerName : String, httpMethods : Array(String))
        @workerName = workerName
        @pattern = ""
        @methodsAllowed = httpMethods
        @guards = [] of Shield.class
      end
    end
  end
end
