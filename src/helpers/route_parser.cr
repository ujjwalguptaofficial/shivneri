module CrystalInsideFort
  module Helpers
    regex1 = /{(.*)}(?!.)/
    regex2 = /{(.*)}\.(\w+)(?!.)/

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
              regMatch1 = patternSplit[i].match(regex1)
              regMatch2 = patternSplit[i].match(regex2)
              if (regMatch1 != null)
                params[regMatch1[1]] = urlPart
              elsif (regMatch2 != null)
                const splitByDot = urlPart.split(".")
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
            if (worker.methodsAllowed.indexOf(httpMethod) >= 0)
              matchedRoute.workerInfo = worker
              matchedRoute.params = params
              matchedRoute.shields = route.shields
              break
            else
              matchedRoute.allowedHttpMethod = [...matchedRoute.allowedHttpMethod, ...worker.methodsAllowed]
            end
          end
        end
      end
      if (matchedRoute.workerInfo == nil && matchedRoute.allowedHttpMethod.length == 0)
        return nil
      end
      return matchedRoute
    end

    def parseRoute(url : String, httpMethod : String)
      url = removeLastSlash(url)
      urlParts = url.split("/")
      route = RouteHandler.findControllerFromPath(urlParts)
      if (route != nil)
        puts "found"
      end
      return route == nil ? checkRouteInWorker(RouteHandler.defaultRoute, httpMethod, urlParts) : checkRouteInWorker(route, httpMethod, urlParts)
    end
  end
end
