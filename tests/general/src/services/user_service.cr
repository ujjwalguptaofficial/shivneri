require "../services/base_service"

module SERVICE
  class UserService < BaseService
    def get_user_by_email(email : String)
      return users.select { |user| user.email == email }
    end

    def get_user_by_id(id : Int32)
      return users.find { |user| user.id == id }
    end

    def get_users
      return self.users
    end

    def add_user(user : User)
      last_user = users[-1]
      user.id = last_user.id + 1
      users.push(user)
      return user
    end

    def update_user(user : User)
      index_of_saved_user = users.index { |q| q.id == user.id }
      if (index_of_saved_user == nil)
        return false
      else
        users[index_of_saved_user.as(Int32)] = user
        return true
      end
    end

    def delete_user(user_id : Int32)
      index_of_saved_user = users.index { |q| q.id == user_id }
      if (index_of_saved_user == nil)
        return false
      else
        users.delete_at(index_of_saved_user.as(Int32))
        return true
      end
    end
  end
end
