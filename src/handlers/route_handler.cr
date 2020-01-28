require "../models/index"

module CrystalInsideFort
  include Models

  module Handlers
    class RouteHandler
      @@routerCollection = {} of String => Models::RouteInfo
    end

    def RouteHandler.addController(controllerId)
        puts controllerId;
      @@routerCollection[controllerId.name] = RouteInfo.new(controllerId)
    end
  end
end
