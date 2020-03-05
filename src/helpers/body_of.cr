module Shivneri
  module HELPER
    # macro body_of(controller_name, worker_name)
    #   {% class_name = controller_name.split("::").last %} 
    #   {% klasses = Controller.all_subclasses.select { |q| q.name.split("::").last == controller_name } %}
    #   {% if klasses.size > 0 %}
    #       return ""
    #   {% else %}
    #     raise "invalid controller name supplied in body_of, #{ {{controller_name}} } is not registered"
    #   {% end %}
    # end
  end
end
