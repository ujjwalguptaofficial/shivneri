require "../models/index"

module SERVICE
  class BaseService
    @@store = [MODEL::User.new(1, "ujjwal", "male", "admin", "ujjwal@mg.com", "India")]

    def users
      return @@store
    end
  end
end