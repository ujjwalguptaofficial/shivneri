module Shivneri
    module MODEL
      class SocketWorkerInfo(T)
        
        getter name, workerProc
  
        @worker_proc : Proc(T, Nil)
  
        def initialize(@name : String,  @worker_proc)
          
        end
  
        # def to_json
        #   return {
        #     "name":            @name,
        #     "pattern":         @pattern,
        #     "methods Allowed": @methodsAllowed.to_json,
        #   }
        # end
      end
    end
  end
  