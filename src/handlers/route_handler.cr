require "../model/index"
require "../helpers/index"

module CrystalInsideFort
  include MODEL
  include HELPER

  module Handlers
    class RouteHandler
      @@routerCollection = {} of String => MODEL::RouteInfo
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
      # iterator = @@routerCollection.each_key

      @@routerCollection.to_a.each do |item|
        puts "controller Name" + item[0]
        isMatched = false
        # controller = @@routerCollection[item.]
        patternSplit = item[1].path.split("/")
        # puts "path:" + controller.path
        patternSplit.each_with_index do |patternPart, i|
          isMatched = patternPart == urlParts[i]
          puts "isMatched" + isMatched.to_s + "patternPart" + patternPart + "url" + urlParts[i]
          break if isMatched == false
        end

        if (isMatched)
          return item[1]
        end
      end
      return nil
    end

    def RouteHandler.defaultRoute
      return @@routerCollection[@@defaultRouteControllerName]
    end

    def RouteHandler.defaultRouteControllerName=(value : String)
      @@defaultRouteControllerName = value
    end
  end
end
