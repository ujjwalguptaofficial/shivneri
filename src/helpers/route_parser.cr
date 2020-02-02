module CrystalInsideFort
  module Helpers
    def checkRouteInWorker(route : RouteInfo, httpMethod : String, urlParts : Array(String))
      matchedRoute = RouteMatch.new(route)
      urlPartLength = urlParts.size

      iterator = route.workers.each_key
      while (workerName = iterator.next)
        worker = route.workers[workerName]
        patternSplit = worker.pattern.split("/")
        if (urlPartLength == patternSplit.size)
          params = {} of String => String | Int32
          isMatched = true
          urlParts.each_with_index do |urlPart, i|
            if (urlPart != patternSplit[i])
              regex1 = /{(.*)}(?!.)/
              regex2 = /{(.*)}\.(\w+)(?!.)/
              regMatch1 = patternSplit[i].scan(regex1).map(&.string)
              regMatch2 = patternSplit[i].scan(regex2).map(&.string)
              # regMatch1 = regex1.match(patternSplit[i])
              # regMatch2 = regex2.match(patternSplit[i])
              if (regMatch1 != nil)
                params[regMatch1[1]] = urlPart
              elsif (regMatch2 != nil)
                splitByDot = urlPart.split(".")
                if (splitByDot[1] === regMatch2[2])
                  params[regMatch2[1]] = splitByDot[0]
                else
                  isMatched = false
                end
              else
                isMatched = false
              end
            end
            break if isMatched == false
          end
          if (isMatched)
            if (worker.methodsAllowed.includes?(httpMethod))
              matchedRoute.workerInfo = worker
              matchedRoute.params = params
              break
            else
              matchedRoute.allowedHttpMethod.concat(matchedRoute.allowedHttpMethod)
              matchedRoute.allowedHttpMethod.concat(worker.methodsAllowed)
            end
          end
        end
      end
      if (matchedRoute.workerInfo == nil && matchedRoute.allowedHttpMethod.size == 0)
        return nil
      end
      return matchedRoute
    end

    def parseRoute(url : String, httpMethod : String)
      url = removeLastSlash(url)
      urlParts = url.split("/")
      route = RouteHandler.findControllerFromPath(urlParts)
      puts route
      if (route != nil)
        puts "found" + route.as(RouteInfo).controllerName
      end
      return route == nil ? checkRouteInWorker(RouteHandler.defaultRoute, httpMethod, urlParts) : checkRouteInWorker(route.as(RouteInfo), httpMethod, urlParts)
    end
  end
end
