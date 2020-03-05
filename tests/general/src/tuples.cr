module General
  def self.user_tuple
    NamedTuple(id: Int32, name: String, password: String, gender: String, email: String, address: String)
  end
end
