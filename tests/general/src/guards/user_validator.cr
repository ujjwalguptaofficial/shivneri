module General
  @[Inject("hello")]
  class UserValidator < Guard
    def initialize(value : String)
      @constructor_value = value
    end

    @[Inject("injection ok in guard")]
    def check(value : String)
      if (query["guard_injection_test"] != nil)
        return text_result("#{@constructor_value} #{value}", 200)
      end
      # if (query["text"] == "as")
      # return text_result("blocked by guard")
      # else
      #   return nil_result
      # end
      # nil_result

    end
  end
end
