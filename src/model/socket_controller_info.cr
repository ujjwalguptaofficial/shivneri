module Shivneri
  module MODEL
    class SocketControllerInfo(T)
      property workers, controller_name
      @controller_name : String
      @workers = {} of String => MODEL::SocketWorkerInfo(T)

      def initialize(@controller_name)
       
      end

    #   def to_json
    #     return {
    #       "controller Name": @controller_name,
    #       "path":            @path,
    #       "workers":         @workers,
    #     }
    #   end
    end
  end
end
