require "./abstracts/index"
require "./annotations/index"
require "./generics/index"
require "http/server"

module CrystalInsideFort
  include Annotations
  include Handlers
  include GENERIC

  # include Enums

  class Fort
    # @server = nil;
    setter port : Int32 = 4000
    setter routes = [] of NamedTuple(controllerName: String, path: String)

    def initialize
      @server = HTTP::Server.new do |context|
        RequestHandler.new(context.request, context.response).handle
        # context.response.content_type = "text/plain"
        # context.response.print "Hello world! The time is #{Time.local}"
      end
    end

    def createObject(val)
      puts val
    end

    def create
      {% for klass in Controller.all_subclasses %}
      
        RouteHandler.addController({{klass.id}})

        {% for method in klass.methods.select { |m| m.annotation(DefaultWorker) } %}
          {% puts "method name is '#{method.name}' '#{method.annotation(DefaultWorker).args[0]}' " %}
          {% mName = "#{method.name}" %}
          action = Proc(HttpResult).new { 
               instance = {{klass}}.new;
               instance.{{method.name}}
               return HttpResult.new
          }
          workerInfo =  WorkerInfo.new({{mName}},["GET"], action)
          RouteHandler.addWorker({{klass}}.name, workerInfo)
        {% end %}

        {% for method in klass.methods.select { |m| m.annotation(Worker) } %}
          {% mName = "#{method.name}" %}
          {% args = method.annotation(Worker).args %}
          action = Proc(HttpResult).new { 
               instance = {{klass}}.new;
               instance.{{method.name}}
               return HttpResult.new
          }
          workerInfo =  WorkerInfo.new({{mName}},{{args}}.to_a, action)
          RouteHandler.addWorker({{klass}}.name, workerInfo)
        {% end %}

        {% for method in klass.methods.select { |m| m.annotation(Route) } %}
          {% mName = "#{method.name}" %}
          {% args = method.annotation(Route).args %}
          RouteHandler.addRoute({{klass}}.name, {{mName}},{{args}}[0])
        {% end %}


      {% end %}

      isDefaultRouteExist = false
      @routes.each do |route|
        RouteHandler.addControllerRoute(route[:controllerName], removeLastSlash(route[:path]))
        if (route[:path] === "/*")
          RouteHandler.defaultRouteControllerName = route[:controllerName]
          isDefaultRouteExist = true
        end
      end

      if (!isDefaultRouteExist)
        RouteHandler.defaultRouteControllerName = GenericController.name
        RouteHandler.addControllerRoute(GenericController.name, "/*")
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
