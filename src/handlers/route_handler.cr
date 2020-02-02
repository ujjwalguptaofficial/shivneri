require "../models/index"
require "../helpers/index"

module CrystalInsideFort
  include Models
  include Helpers

  module Handlers
    class RouteHandler
      @@routerCollection = {} of String => Models::RouteInfo
      @@defaultRouteControllerName : String = ""
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
          @@routerCollection[key].path = path
          return
        end
      end

      raise "No controller found for controller name #{controllerName}"
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

    def RouteHandler.findControllerFromPath(urlParts : Array(String))
      iterator = @@routerCollection.each_key

      while (controllerName = iterator.next.to_s)
        isMatched = false
        controller = @@routerCollection[controllerName]
        patternSplit = controller.path.split("/")
        puts "path:" + controller.path
        patternSplit.each_with_index do |patternPart, i|
          isMatched = patternPart == urlParts[i]
          puts "isMatched" + isMatched.to_s + "patternPart" + patternPart + "url" + urlParts[i]
          break if isMatched == false
        end

        if (isMatched)
          return controller
        end
      end
      return nil
    end

    def RouteHandler.defaultRoute
      return @@routerCollection[@@defaultRouteControllerName]
    end
  end
end
