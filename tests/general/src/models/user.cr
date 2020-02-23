module MODEL
  class User
    property id, name, gender, password, email, address

    def initialize(body_data : Hash(String, JSON::Any))
      @id = body_data.has_key?("id") ? body_data["id"] : 0
      @name = body_data["name"]
      @gender = body_data["gender"]
      @password = body_data["password"]
      @email = body_data["email"]
      @address = body_data["address"]
    end

    def initialize(@id : Int32, @name : String, @gender : String, @password : String, @email : String, @address : String)
    end
  end
end
