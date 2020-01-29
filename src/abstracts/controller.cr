require "../handlers/index"
require "../annotations/index"

module CrystalInsideFort
  module Abstracts
    abstract class Controller
      include Handlers
      include Annotations

      @query = {} of String => String | Int32

      # {% puts @type.name.id + "Parent1" %}
      macro inherited
    
      # {% klass = @type %}
      #   RouteHandler.addController({{klass}})
      #   {% for method in klass.methods.select { |m| m.annotation(DefaultWorker) } %}
      #     {% puts "methodss name is '#{method.name}' '#{method.annotation(DefaultWorker).args[0]}' " %}
      #   {% end %}
      #   #{% for method in klass.annotations(CrystalInsideFort::DefaultWorker) %}
       

      #   # puts {{klass.annotation(DefaultWorker).args}}
      # {% end %}
    end
    end
  end
end
