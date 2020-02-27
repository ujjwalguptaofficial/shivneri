module Shivneri
  module MODEL
    class WorkerInfo
      property pattern, methodsAllowed, guards
      getter name, workerProc

      @pattern : String

      @guards = [] of String
      @workerProc : Proc(RequestHandler, HttpResult)

      # values = [] of any;
      # expectedQuery?: any;
      # expectedBody?: any;

      def initialize(workerName : String, httpMethods : Array(String), @workerProc)
        @name = workerName
        @pattern = "/#{workerName}"
        @methodsAllowed = httpMethods.size == 0 ? HTTP_METHOD.values : httpMethods
      end

      def to_json
        return {
          "name":            @name,
          "pattern":         @pattern,
          "methods Allowed": @methodsAllowed.to_json,
        }
      end
    end
  end
end
