require "../model/index"
require "../helpers/index"

module CrystalInsideFort
  include MODEL
  include HELPER
  alias ComponentResult = Nil | HttpResult

  module Handlers
    class RouteHandler
      @@routerCollection = {} of String => MODEL::RouteInfo
      @@shield_store = {} of String => Proc(RequestHandler, HttpResult) | Proc(RequestHandler, Nil)
      @@guard_store = {} of String => Proc(RequestHandler, ComponentResult)
      @@defaultRouteControllerName : String = ""
    end

    def RouteHandler.addController(controller)
      controller_name = get_class_name(controller.name)
      @@routerCollection[controller_name] = RouteInfo.new(controller)
    end

    def RouteHandler.add_shield(shield_name, executor_proc)
      puts "shield name : #{shield_name}"
      shield_name = get_class_name(shield_name)
      if (!@@shield_store.has_key?(shield_name))
        @@shield_store[shield_name] = executor_proc
        # .as(Proc(RequestHandler, (HttpResult | Nil)))
      end
    end

    def RouteHandler.add_guard(guard_name, executor_proc)
      puts "shield name : #{guard_name}"
      guard_name = get_class_name(guard_name)
      if (!@@shield_store.has_key?(guard_name))
        @@guard_store[guard_name] = executor_proc
        # .as(Proc(RequestHandler, HttpResult | Nil))
      end
    end

    # def RouteHandler.get_shield_executor(shields_name)
    #   return @@shield_store.each_key do |shield_name|
    #   end
    # end

    def RouteHandler.add_shield_in_controller(controller_name : String, shield_name : String)
      shield_name = get_class_name(shield_name)
      controller_name = get_class_name(controller_name)
      if (@@shield_store.has_key?(shield_name))
        # @@routerCollection[controller_name].shields.push(@@shield_store[shield_name])
        @@routerCollection[controller_name].shields.push(shield_name)
      else
        raise "No Shield found for shield name #{shield_name}"
      end
    end

    def RouteHandler.add_guard_in_worker(controller_name : String, worker_name, guard_name : String)
      guard_name = get_class_name(guard_name)
      controller_name = get_class_name(controller_name)
      if (@@guard_store.has_key?(guard_name))
        # @@routerCollection[controller_name].shields.push(@@shield_store[shield_name])
        @@routerCollection[controller_name].workers[worker_name].guards.push(guard_name)
      else
        raise "No Guard found with name #{guard_name}"
      end
    end

    def RouteHandler.addControllerRoute(controller_name, path)
      controller_name = get_class_name(controller_name)
      iterator = @@routerCollection.each_key

      while (key = iterator.next.to_s)
        if (key.includes?(controller_name))
          @@routerCollection[key].path = path
          return
        end
      end

      raise "No controller found for controller name #{controller_name}"
    end

    def RouteHandler.addWorker(controller_name, workerInfo : WorkerInfo)
      controller_name = get_class_name(controller_name)
      worker_name = get_class_name(workerInfo.name)
      @@routerCollection[controller_name].workers[worker_name] = workerInfo
    end

    def RouteHandler.addRoute(controller_name, worker_name : String, format : String)
      controller_name = get_class_name(controller_name)
      worker_name = get_class_name(worker_name)
      if (@@routerCollection[controller_name].workers.has_key?(worker_name))
        if (format != nil)
          format = removeLastSlash(format)
        end
        controllerPath = @@routerCollection[controller_name].path
        format = controllerPath.empty? || controllerPath === "/*" ? format : "#{controllerPath}#{format}"
        @@routerCollection[controller_name].workers[worker_name].pattern = format
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

    def RouteHandler.defaultRouteControllerName=(controller_name : String)
      controller_name = get_class_name(controller_name)
      @@defaultRouteControllerName = controller_name
    end

    def RouteHandler.get_shield_proc(shield_name)
      return @@shield_store[shield_name]
    end

    def RouteHandler.get_guard_proc(guard_name)
      return @@guard_store[guard_name]
    end
  end
end
