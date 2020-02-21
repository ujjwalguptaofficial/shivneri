require "./abstracts/index"
require "./annotations/index"
require "./generics/index"
require "http/server"
require "./helpers/index"
require "./handlers/index"
require "./structs/index"

module CrystalInsideFort
  include Annotations
  include Handlers
  include GENERIC
  include STRUCT

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

    private def add_workers
      {% for klass in Controller.all_subclasses %}

      {% for method in klass.methods.select { |m| m.annotation(DefaultWorker) } %}
        {% mName = "#{method.name}" %}
          action = -> (ctx : RequestHandler) { 
              instance = {{klass}}.new;
              instance.set_context(ctx);
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
          instance.set_context(ctx);
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

      {% for method in klass.methods.select { |m| m.annotation(Guards) } %}
        {% mName = "#{method.name}" %}
        {% args = method.annotation(Guards).args %}
        RouteHandler.add_guard_in_worker({{klass}}.name, {{mName}},{{args}}[0].name)
      {% end %}

      {% end %}
    end

    private def add_shield
      puts "adding shield"
      {% for klass in Shield.all_subclasses %}
        puts "found shield"
        shield_executor = -> (ctx : RequestHandler) {
          instance = {{klass}}.new;
          instance.set_context(ctx);
          # return instance.protect
          if(true)
            return instance.protect
          elsif(ctx.body.has_key?("garbage_value_test"))
            return nil
          end
          return HttpResult.new("garbage result from framework", MIME_TYPE["text"])
        }
        RouteHandler.add_shield({{klass}}.name, shield_executor)
      {% end %}
    end

    private def add_guard
      puts "adding guard"
      {% for klass in Guard.all_subclasses %}
        puts "found guard"
        guard_executor =  -> (ctx : RequestHandler){
          instance = {{klass}}.new;
          instance.set_context(ctx);
          if(true)
            return instance.check
          elsif(ctx.body.has_key?("garbage_value_test"))
            return nil
          end
          return HttpResult.new("garbage result from framework", MIME_TYPE["text"])
        }
        RouteHandler.add_guard({{klass}}.name, guard_executor)
      {% end %}
    end

    private def add_controller_route_and_map_shields
      {% for klass in Controller.all_subclasses %}
        RouteHandler.addController({{klass}})
        {% if shields = klass.annotation(Shields) %}
          {% args = shields.args %}
          {% if !args.empty? %}
            {{args}}.each do |shield|
              RouteHandler.add_shield_in_controller({{klass}}.name, shield.name)
            end
          {% end %}
        {% end %}
      {% end %}

      isDefaultRouteExist = false
      @routes.each do |route|
        RouteHandler.addControllerRoute(route[:controllerName], remove_last_slash(route[:path]))
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
          instance.set_context(ctx);
          return instance.as(Wall);
        }
        if(!{{klass}}.name.includes?("GenericWall"))
        FortGlobal.walls.push(create_wall_instance)
      end
      {% end %}
    end

    # def create
    #   app_option = AppOption.new;
    #   app_option.folders = [{

    #   }]
    #   self.create()
    # end

    private def save_option(option : AppOption)
      FortGlobal.folders = option.folders
    end

    def create(option : AppOption = AppOption.new)
      add_shield
      puts "adding controller"
      add_controller_route_and_map_shields
      puts "adding actions"
      add_guard
      add_workers
      puts "adding wall"
      add_walls

      save_option(option)
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
