require "../models/index"

module CrystalInsideFort
  include Models

  module Handlers
    class RouteHandler
      @@routerCollection = {} of String => Models::RouteInfo
    end

    def RouteHandler.addController(controller)
      # puts controllerId;
      @@routerCollection[controller.name] = RouteInfo.new(controller)
    end

    def RouteHandler.getRouteValues
      return @@routerCollection.values
    end
  end
end
