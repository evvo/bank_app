module BankApp
  class UserService
    def self.get_current_user_id(env)
      env.get("current_user").as(User).id
    end
  end
end