require "../models/index"

module SERVICE
  class EmployeeService
    def get_all
      return [{
        id:   1,
        name: "ujjwal",
        type: "employee",
      }]
    end
  end
end
