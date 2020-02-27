require "../models/index"

module SERVICE
  class StudentService
    def get_all
      return [{
        id:   1,
        name: "ujjwal",
        type: "student",
      }]
    end
  end
end
