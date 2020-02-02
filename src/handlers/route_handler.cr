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
      puts controller.name
      @@routerCollection[controller.name] = RouteInfo.new(controller)
    end

    def RouteHandler.addControllerRoute(controllerName, path)
      iterator = @@routerCollection.each_key

      while (key = iterator.next.to_s)
        if (key.includes?(controllerName))
          return
        end
      end

      if (@@routerCollection.has_key?(controllerName))
        @@routerCollection[controllerName].path = path
      else
        raise "No controller found for controller name #{controllerName}"
      end
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
