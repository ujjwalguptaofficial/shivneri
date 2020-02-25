require "json"

module CrystalInsideFort
  module HELPER
    def checkRouteInWorker(route : RouteInfo, httpMethod : String, urlParts : Array(String))
      matchedRoute = RouteMatch.new(route.controllerName, route.shields)
      urlPartLength = urlParts.size
      route.workers.to_a.each do |item|
        worker = item[1]
        patternSplit = worker.pattern.split("/")
        if (urlPartLength == patternSplit.size)
          params = {} of String => String | Int32
          isMatched = true
          urlParts.each_with_index do |urlPart, i|
            if (urlPart != patternSplit[i])
              regex1 = /{(.*)}(?!.)/
              regex2 = /{(.*)}\.(\w+)(?!.)/
              regMatch1 = patternSplit[i].match(regex1) # patternSplit[i].scan(regex1).map(&.string)
              regMatch2 = patternSplit[i].match(regex2)
              if (regMatch1 != nil)
                params[regMatch1.as(Regex::MatchData).captures[0].as(String)] = urlPart
              elsif (regMatch2 != nil)
                regMatch2Captures = regMatch2.as(Regex::MatchData).captures
                splitByDot = urlPart.split(".")
                if (splitByDot[1] === regMatch2Captures[1])
                  params[regMatch2Captures[0].as(String)] = splitByDot[0]
                else
                  isMatched = false
                end
              else
                isMatched = false
              end
            end
          end
          if (isMatched)
            if (worker.methodsAllowed.includes?(httpMethod))
              matchedRoute.worker_info = worker
              matchedRoute.params = params
              break
            else
              matchedRoute.allowedHttpMethod.concat(matchedRoute.allowedHttpMethod)
              matchedRoute.allowedHttpMethod.concat(worker.methodsAllowed)
            end
          end
        end
      end
      if (matchedRoute.worker_info == nil && matchedRoute.allowedHttpMethod.size == 0)
        return nil
      end
      return matchedRoute
    end

    def parseRoute?(url : String, httpMethod : String) : RouteMatch | Nil
      url = remove_last_slash(url)
      urlParts = url.split("/")
      route = RouteHandler.findControllerFromPath(urlParts)
      return route == nil ? checkRouteInWorker(RouteHandler.defaultRoute, httpMethod, urlParts) : checkRouteInWorker(route.as(RouteInfo), httpMethod, urlParts)
    end
  end
end
