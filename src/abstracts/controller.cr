require "../handlers/index"

module CrystalInsideFort
  abstract class Controller
    include Handlers
    @query = {} of String => String | Int32

    macro inherited
      {% puts @type.name.id + "Parent1" %}  
      {% klass = @type.name.id %}
      RouteHandler.addController({{klass}})
    end
  end
end
