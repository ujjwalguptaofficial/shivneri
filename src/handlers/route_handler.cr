require "../model/index"
require "../helpers/index"

module CrystalInsideFort
  include MODEL
  include HELPER

  module Handlers
    class RouteHandler
      @@routerCollection = {} of String => MODEL::RouteInfo
      @@shield_store = {} of String => Proc(RequestHandler, HttpResult | Nil)
      @@defaultRouteControllerName : String = ""
    end

    def RouteHandler.addController(controller)
      @@routerCollection[controller.name] = RouteInfo.new(controller)
    end

    def RouteHandler.add_shield(shield_name, executor_proc)
      puts "shield name : #{shield_name}"
      @@shield_store[shield_name.split("::").last] = executor_proc
      puts @@shield_store.to_json
    end

    def RouteHandler.add_shield_in_controller(controller_name, shield_name)
      if (@@shield_store.has_key?(shield_name))
        @@routerCollection[controller_name].shields.push(@@shield_store[shield_name])
      else
        raise "No Shield found for shield name #{shield_name}"
      end
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

    def RouteHandler.addWorker(controllerName, workerInfo : WorkerInfo)
      @@routerCollection[controllerName].workers[workerInfo.name] = workerInfo
    end

    def RouteHandler.addRoute(controllerName, methodName : String, format : String)
      if (@@routerCollection[controllerName].workers.has_key?(methodName))
        if (format != nil)
          format = removeLastSlash(format)
        end
        controllerPath = @@routerCollection[controllerName].path
        format = controllerPath.empty? || controllerPath === "/*" ? format : "#{controllerPath}#{format}"
        @@routerCollection[controllerName].workers[methodName].pattern = format
      end
    end

    def RouteHandler.getRouteValues
      return @@routerCollection.values
    end

    def RouteHandler.findControllerFromPath(urlParts : Array(String))
      @@routerCollection.to_a.each do |item|
        isMatched = false
        patternSplit = item[1].path.split("/")
        patternSplit.each_with_index do |patternPart, i|
          isMatched = patternPart == urlParts[i]
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
