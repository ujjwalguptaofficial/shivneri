require "../models/index"
require "../helpers/index"

module CrystalInsideFort
  include Models
  include Helpers

  module Handlers
    class RouteHandler
      @@routerCollection = {} of String => Models::RouteInfo
    end

    def RouteHandler.addController(controller)
      # controller.new
      @@routerCollection[controller.name] = RouteInfo.new(controller)
    end

    def RouteHandler.addWorker(controllerName, methodName : String, httpMethod : Array(String))
      # puts "controller Name" + controllerName
      @@routerCollection[controllerName].workers[methodName] = WorkerInfo.new(methodName, httpMethod)
    end

    def RouteHandler.addRoute(controllerName, methodName : String, format : String)
      if (@@routerCollection[controllerName].workers.has_key?(methodName))
        if (format != nil)
          format = removeLastSlash(format)
        end
        @@routerCollection[controllerName].workers[methodName].pattern = format
      end
    end

    def RouteHandler.getRouteValues
      return @@routerCollection.values
    end
  end
end
