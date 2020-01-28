module CrystalInsideFort
  module Models
    class WorkerInfo
    
      
      # guards: Array<typeof GenericGuard>;
   
      # values = [] of any;
      # expectedQuery?: any;
      # expectedBody?: any;

      def initialize
        @workerName : String = ""
        @pattern : String = ""
        @methodsAllowed = [] of HTTP_METHOD
      end
    end
  end
end
