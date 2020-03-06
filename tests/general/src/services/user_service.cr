require "../services/base_service"

module SERVICE
  class UserService < BaseService
    def get_user_by_email(email : String)
      return users.select { |user| user.email == email }
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
  end
end
