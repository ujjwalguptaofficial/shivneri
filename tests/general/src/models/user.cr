module General
  module MODEL
    class User
      include JSON::Serializable
      # include Shivneri::Model
      property id, name, gender, password, email, address

      def initialize
        @id = 0
        @name = ""
        @gender = ""
        @password = ""
        @email = ""
        @address = ""
      end

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
end
