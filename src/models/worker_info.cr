module CrystalInsideFort
  module Models
    class WorkerInfo
      property pattern
      setter pattern : String

      # guards: Array<typeof GenericGuard>;

      # values = [] of any;
      # expectedQuery?: any;
      # expectedBody?: any;

      def initialize(workerName : String, httpMethods : Array(String))
        @workerName = workerName
        @pattern = ""
        @methodsAllowed = httpMethods
      end
    end
  end
end
