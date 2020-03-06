module MODEL
  class User
    include JSON::Serializable
    property id, name, gender, password, email, address

    def initialize(user)
      @id = user[:id]
      @name = user[:name]
      @gender = user[:gender]
      @password = user[:password]
      @email = user[:email]
      @address = user[:address]
      # , , , , "ujjwal@mg.com", "India"
    end

    def initialize(@id : Int32, @name : String, @gender : String, @password : String, @email : String, @address : String)
    end
  end
end
