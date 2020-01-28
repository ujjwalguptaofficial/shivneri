class MyRouter
  def addRoute(val)
    puts "className" + val.name
  end

end

router = MyRouter.new;

class Parent

  macro inherited
    {% puts  @type.name.id + "Parent1" %}
    {% klass = @type %}
    MyRouter.add({{@type}})
    #{{klass}}.new
  end
end

class Child1 < Parent
  def initialize
    MyRouter.add("asdssf");
  end
end

# class Child2 < Parent
# end

def MyRouter.add(val): Nil
  # puts "className" + val
  puts  typeof(val.name)
end

def MyRouter.addByLoop()
  {% for c in Parent.all_subclasses %}
  {% klass = c.id %}
    MyRouter.add({{klass}})
  {% end %}
end

# Child.new.lineage
#MyRouter.add("asdf");

# module MyModule
#   class MyClass
#     @firstName = ""
#     @lastName = ""
#   end
# end

# value = {} of String => MyModule::MyClass
# value["1"] = MyModule::MyClass.new
