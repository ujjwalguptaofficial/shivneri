# class MyRouter
#   def addRoute(val)
#     puts "className" + val.name
#   end

# end

# router = MyRouter.new;

# class Parent

#   macro inherited
#     {% puts  @type.name.id + "Parent1" %}
#     {% klass = @type %}
#     MyRouter.add({{@type}})
#     #{{klass}}.new
#   end
# end

# class Child1 < Parent
#   def initialize
#     MyRouter.add("asdssf");
#   end
# end

# # class Child2 < Parent
# # end

# def MyRouter.add(val): Nil
#   # puts "className" + val
#   puts  typeof(val.name)
# end

# def MyRouter.addByLoop()
#   {% for c in Parent.all_subclasses %}
#   {% klass = c.id %}
#     MyRouter.add({{klass}})
#   {% end %}
# end

# Child.new.lineage
# MyRouter.add("asdf");

# module MyModule
#   class MyClass
#     @firstName = ""
#     @lastName = ""
#   end
# end

# value = {} of String => MyModule::MyClass
# value["1"] = MyModule::MyClass.new
module MyModule
  annotation MyAnnotation
  end
end

module MyModule1
  @[MyModule::MyAnnotation(2)]
  class MyClass
    @[MyModule::MyAnnotation(3)]
    def me
      puts "hey"
    end
  end
end

def annotation_value
  # The name can be a `String`, `Symbol`, or `MacroId`
  puts {{ MyModule1::MyClass.annotation(MyModule::MyAnnotation).args }}
  puts {{ MyModule1::MyClass.methods[0].annotation(MyModule::MyAnnotation).args }}
  # myVar = MyModule1::MyClass.new.{{MyModule1::MyClass.methods[0].name}}
  # puts myVar
end

# {{ method = MyModule1::MyClass.methods[0].name }}
# puts {{method}}
# {% end %}

# annotation_value
# {{instance = MyModule1::MyClass.new}}
# #MyModule1::MyClass.call
# ->{ %instance = {{klass.id}}.new; ->%instance.{{m.name.id}}{% if m.args.size > 0 %}({{arg_types.splat}}){% end %} }

VALUES = MyModule1::MyClass.id

{% for method in VALUES.methods %}
  {% mName = "#{method.name}" %}
  puts {{mName}}
{% end %}
