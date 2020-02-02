module CrystalInsideFort
  module Helpers
    def checkRouteInWorker(route : RouteInfo, httpMethod : String, urlParts : Array(String))
      
    end

    def parseRoute(url : String, httpMethod : String)
      url = removeLastSlash(url)
      urlParts = url.split("/")
      route = RouteHandler.findControllerFromPath(urlParts)
      if (route != nil)
        puts "found"
      end
      #  return route==nil ? puts "not found": puts "found"
      # return route == null ? checkRouteInWorker(RouteHandler.defaultRoute, httpMethod, urlParts) : checkRouteInWorker(route, httpMethod, urlParts)
    end
  end
end
