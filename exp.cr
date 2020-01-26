class MyRouter
  def addRoute(val)
    puts val
  end

end

def MyRouter.add(val): Nil
  puts val
end

router = MyRouter.new;

class Parent
 
  macro inherited
     puts "{{@type.name.id}} < Parent"
      #puts Router.add(@type)
      #{{ MyRouter.add(@type.name.id) }}

    
  end
end

class Child1 < Parent
  def initialize
    MyRouter.add("asdf");
  end
end

class Child2 < Parent
end

# Child.new.lineage
MyRouter.add("asdf");