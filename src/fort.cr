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
    @error_handler : MODEL::ErrorHandler.class = ErrorHandler
    @walls = [] of Wall.class
    setter port : Int32 = 4000
    setter routes = [] of NamedTuple(controllerName: String, path: String)

    setter error_handler, walls

    def initialize
      @server = HTTP::Server.new do |context|
        RequestHandler.new(context.request, context.response).handle
        # context.response.content_type = "text/plain"
        # context.response.print "Hello world! The time is #{Time.local}"
      end
    end

    private def add_actions
      {% for klass in Controller.all_subclasses %}

      {% for method in klass.methods.select { |m| m.annotation(DefaultWorker) } %}
        {% puts "method name is '#{method.name}' '#{method.annotation(DefaultWorker).args[0]}' " %}
        {% mName = "#{method.name}" %}
          action = -> (ctx : RequestHandler) { 
              instance = {{klass}}.new;
              instance.context = ctx;
              return instance.{{method.name}}
              #  return HttpResult.new
          }
          workerInfo =  WorkerInfo.new({{mName}},["GET"], action)
          RouteHandler.addWorker({{klass}}.name, workerInfo)
          RouteHandler.addRoute({{klass}}.name, {{mName}},"/")
        {% end %}

      {% for method in klass.methods.select { |m| m.annotation(Worker) } %}
        {% mName = "#{method.name}" %}
        {% args = method.annotation(Worker).args %}
        action = -> (ctx : RequestHandler) { 
          instance = {{klass}}.new;
          instance.context = ctx;
          return instance.{{method.name}}
        }
        http_methods = [] of String;
        {% if !args.empty? %}
            http_methods = {{args}}.to_a
        {% end %}
         
        workerInfo =  WorkerInfo.new({{mName}},http_methods, action)
        RouteHandler.addWorker({{klass}}.name, workerInfo)
        RouteHandler.addRoute({{klass}}.name, {{mName}},"/#{workerInfo.name}")
      {% end %}

      {% for method in klass.methods.select { |m| m.annotation(Route) } %}
        {% mName = "#{method.name}" %}
        {% args = method.annotation(Route).args %}
        RouteHandler.addRoute({{klass}}.name, {{mName}},{{args}}[0])
      {% end %}


      {% end %}
    end

    private def add_controller_route
      {% for klass in Controller.all_subclasses %}

        RouteHandler.addController({{klass.id}})

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
    end

    private def add_walls
      {% for klass in Wall.all_subclasses %}
        create_wall_instance = -> (ctx : RequestHandler) { 
          instance = {{klass}}.new;
          instance.context = ctx;
          return instance.as(Wall);
        }
        if(!{{klass}}.name.includes?("GenericWall"))
        FortGlobal.walls.push(create_wall_instance)
      end
      {% end %}
    end

    def create
      add_controller_route
      add_actions
      add_walls

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
