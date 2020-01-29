require "./abstracts/index"
require "./annotations/index"
require "http/server"

module CrystalInsideFort
  include Annotations
  include Handlers

  class Fort
    # @server = nil;
    setter port : Int32 = 4000
    setter routes = [] of NamedTuple(controllerName: String, path: String)

    def initialize
      @server = HTTP::Server.new do |context|
        context.response.content_type = "text/plain"
        context.response.print "Hello world! The time is #{Time.local}"
      end
    end

    def createObject(val)
      puts val
    end

    def create
      # puts Controller.name;
      # Controller.all_subclasses.each do |controller|
      #   puts "controller name: #{controller.name}"
      # end

      # {% for c in Controller.all_subclasses %}
      # # puts "c"
      # {% self.createObject(c.id) %}

      # {% end %}

      # self.createObject 1

      # @routes.each do |route|
      #   puts "route controller name #{route[:controllerName]}"
      # end
      # puts "routes length"
      # puts {{klass.annotations(DefaultWorker)}}
      RouteHandler.getRouteValues().each do |klass|
        # puts klass
        # puts {{ @def.annotation(DefaultWorker)[:value] }}
        # {% for method in @def.annotation(Annotations::DefaultWorker) %}
        # puts {{method}}
        # {% end %}
      end
      address = @server.bind_tcp @port
      puts "Your fort is available on http://#{address}"
      @server.listen
    end

    def finalize
      @server.close
    end
  end
end

# app = Fort.new
# app.routes = [{
#   controllerName: "DefaultController",
#   path:           "/default",
# }]
# # app.routes = ["as"]
# app.port = 3000
# app.create
