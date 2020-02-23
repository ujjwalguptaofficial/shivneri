require "../services/base_service"

module SERVICE
  class UserService < BaseService
    def get_user_by_email(email : String)
      return users.select { |user| user.email == email }
    end
  end
end
