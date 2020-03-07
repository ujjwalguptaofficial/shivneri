require "../fort_global"
require "../abstracts/index"
require "../annotations/index"
require "../generics/index"
require "http/server"
require "../helpers/index"
require "../handlers/index"
require "../structs/index"

module Shivneri
  include ANNOTATION
  include Handlers
  include GENERIC
  include STRUCT

  if (ENV.has_key?("CRYSTAL_ENV") == false)
    ENV["CRYSTAL_ENV"] = "development"
  end

  def self.port
    return Fort.instance.port
  end

  def self.add_wall(wall)
    # @walls.push(wall)
  end

  def self.walls=(walls)
    walls.each do |wall|
      add_wall(wall)
    end
  end

  def self.open(option : AppOption = AppOption.new)
    Fort.instance.create(option)
  end

  def self.open(option : AppOption = AppOption.new, on_success : Proc(Nil) = ->{})
    Fort.instance.create(option, on_success)
  end

  def self.open(option : AppOption = AppOption.new, on_success : Nil = nil)
    Fort.instance.create(option)
  end

  # def self.open(option : AppOption = AppOption.new)
  #   Fort.instance.create(option, ->{})
  # end

  def self.close
    Fort.instance.destroy
  end

  def self.routes=(routes)
    routes.each do |route|
      Fort.instance.register_controller(route[:controller], route[:path])
    end
  end

  def self.port=(port : Int32)
    Fort.instance.port = port
  end

  class Fort
    property port
    @@instance = Fort.new

    def self.instance
      return @@instance
    end

    # @server = nil;
    @error_handler : MODEL::ErrorHandler.class = ErrorHandler
    @walls = [] of Wall.class
    @port : Int32 = 4000
    @routes = [] of NamedTuple(controller_name: String, path: String)

    setter error_handler

    def register_controller(controller, path : String)
      @routes.push({controller_name: controller.name, path: path})
    end

    def initialize
      @server = HTTP::Server.new do |context|
        RequestHandler.new(context.request, context.response).handle
      end
    end

    private def add_workers
      {% for klass in Controller.all_subclasses %}
      {% if klass_inject = klass.annotation(Inject) %}
          {% klass_inject_args = klass_inject.args %}
          {% is_klass_has_args = true %}
        {% else %}
          {% is_klass_has_args = false %}
        {% end %}
        {% for method in klass.methods.select { |m| m.annotation(DefaultWorker) || m.annotation(Worker) } %}
          {% method_name = "#{method.name}" %}
          {% inject_annotation = method.annotation(Inject) %}
          {% if inject_annotation %}
              {% worker_inject_args = inject_annotation.args %}
              {% is_worker_has_args = true %}
          {% elsif method.args.size > 0 %}
              raise "method " + {{method_name}} + " in controller #{ {{klass.name}} } expects some arguments, use Inject for passing arguments value."
              return;
          {% else %}
            {% is_worker_has_args = false %}
          {% end %}
            action = -> (ctx : RequestHandler) { 
              {% if is_klass_has_args == true %}
                instance = {{klass}}.new(*{{klass_inject_args}})
              {% else %}
                instance = {{klass}}.new
              {% end %}
              instance.set_context(ctx);
              {% if is_worker_has_args == true %}
                {% if body_tuple = method.annotation(ExpectBody) %}
                  return instance.{{method.name}}(*{
                    {% for value in worker_inject_args %}
                      {% if value == "as_body" %}
                        {% vars = body_tuple.args[0].resolve.instance_vars %}
                        {{body_tuple.args[0].resolve}}.new({
                            {% for prop, index in vars %}
                                {% key_as_string = prop.stringify %}
                                {% type_as_string = prop.type.stringify %}
                                {{prop}}: (ctx.body.has_key?({{key_as_string}})? 
                                  convert_to({{key_as_string}}, ctx.body[{{key_as_string}}], {{type_as_string}}) : 
                                  get_default_value({{type_as_string}})).as({{prop.type}}) , 
                            {% end %}
                        }),
                      {% else %}
                        {{value}}
                      {% end %}
                    {% end %}
                  })
                {% else %}
                  return instance.{{method.name}}(*{{worker_inject_args}})
                {% end %}
              {% else %}
                return instance.{{method.name}}
              {% end %}
            }
            {% if method.annotation(Worker) %}
              {% worker_route = "/" + method_name %}
              {% worker_args = method.annotation(Worker).args %}
              {% if worker_args.empty? %}
                http_methods = [] of String
              {% else %}
                http_methods = {{worker_args}}.to_a;  
              {% end %}
           {% else %}
              {% worker_route = "/" %}
              http_methods = ["GET"]
           {% end %}
            workerInfo =  WorkerInfo.new({{method_name}},http_methods, action)
            RouteHandler.addWorker({{klass}}.name, workerInfo)
            RouteHandler.addRoute({{klass}}.name, {{method_name}}, {{worker_route}})
        {% end %}

      {% for method in klass.methods.select { |m| m.annotation(Route) } %}
        {% method_name = "#{method.name}" %}
        {% args = method.annotation(Route).args %}
        RouteHandler.addRoute({{klass}}.name, {{method_name}},{{args}}[0])
      {% end %}

      {% for method in klass.methods.select { |m| m.annotation(Guards) } %}
        {% method_name = "#{method.name}" %}
        {% args = method.annotation(Guards).args %}
        RouteHandler.add_guard_in_worker({{klass}}.name, {{method_name}},{{args}}[0].name)
      {% end %}

      {% end %}
    end

    private def add_shield
      {% for klass in Shield.all_subclasses %}
        shield_executor = -> (ctx : RequestHandler) {
          instance = {{klass}}.new;
          instance.set_context(ctx);
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
      {% for klass in Guard.all_subclasses %}
        {% if klass_inject = klass.annotation(Inject) %}
          {% klass_inject_args = klass_inject.args %}
          {% is_klass_has_args = true %}
        {% else %}
          {% is_klass_has_args = false %}
        {% end %}
        guard_executor =  -> (ctx : RequestHandler){
          {% if is_klass_has_args == true %}
            instance = {{klass}}.new(*{{klass_inject_args}})
          {% else %}
            instance = {{klass}}.new
          {% end %}
          instance.set_context(ctx);
          if(true)
            error_message = "Guard #{ {{klass.name}} } expect some arguments in method check, use Inject annotation for dependency injection." 
            {% check_method = klass.methods.select { |q| q.name == "check" }[0] %}
            {% if guard_inject_annoation = check_method.annotation(Inject) %}
              {% if guard_inject_annoation.args.size == check_method.args.size %}
                {% if body_tuple = check_method.annotation(ExpectBody) %}
                  return instance.check(*{
                    {% for value in guard_inject_annoation.args %}
                      {% if value == "as_body" %}
                        {{body_tuple.args[0]}}.get_tuple_from_hash_json_any.call(ctx.body.as_hash),
                      {% else %}
                        {{value}},
                      {% end %}
                    {% end %}
                  })
                {% elsif target_body = check_method.annotation(BodySameAs) %}
                  return instance.check(*{
                    {% for value in guard_inject_annoation.args %}
                      {% if value == "as_body" %}
                        {% controller_name = target_body[0].split("::").last %} 
                        {% klasses = Controller.all_subclasses.select { |q| q.name.split("::").last == controller_name } %}
                        {% if klasses.size > 0 %}
                          {% methods = klasses[0].methods.select { |q| q.name == target_body[1] } %}
                          {% if methods.size > 0 %}
                            {% if body_tuple = methods[0].annotation(ExpectBody) %}
                              {{body_tuple.args[0]}}.get_tuple_from_hash_json_any.call(ctx.body.as_hash),
                            {% else %}
                              raise "expected body is not defined"
                            {% end %}
                          {% else %}
                            raise "invalid method name supplied in body_of, #{ {{target_body[1]}} } can not be found in class #{ {{controller_name}} }"
                          {% end %}
                        {% else %}
                          raise "invalid controller name supplied in body_of, #{ {{controller_name}} } is not registered"
                        {% end %}
                        
                      {% else %}
                        {{value}},
                      {% end %}
                    {% end %}
                  })
                {% else %}
                  return instance.check(*{{guard_inject_annoation.args}})
                {% end %}
              {% else %}
                raise "Guard #{ {{klass.name}} } expect #{ {{check_method.args.size}} } arguments in method check but supplied #{ {{guard_inject_annoation.args.size}} }, use Inject annotation for dependency injection." ;
              {% end %}
            {% elsif check_method.args.size > 0 %}
              raise error_message
            {% else %}
              return instance.check
            {% end %}
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
        RouteHandler.addControllerRoute(route[:controller_name], remove_last_slash(route[:path]))
        if (route[:path] == "/*")
          RouteHandler.defaultRouteControllerName = route[:controller_name]
          isDefaultRouteExist = true
        end
      end
      if (isDefaultRouteExist)
        RouteHandler.remove_controller_route(GenericController.name)
      else
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

    private def save_option(option : AppOption)
      FortGlobal.folders = option.folders
    end

    # def create(option : AppOption = AppOption.new, on_success = nil)
    #   create(option)
    # end

    def create(option : AppOption = AppOption.new, on_success : Proc(Nil) = ->{})
      add_shield
      add_controller_route_and_map_shields
      add_guard
      add_workers
      add_walls

      save_option(option)
      address = @server.bind_tcp @port
      env = ENV["CRYSTAL_ENV"]
      if (env.downcase == "test")
        spawn do
          @server.listen
        end
      else
        on_success.call
        @server.listen
      end
    end

    def destroy
      @server.close
    end

    def finalize
      destroy
    end
  end
end
