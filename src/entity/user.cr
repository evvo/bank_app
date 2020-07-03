module BankApp
  class User
    include JSON::Serializable

    getter id : String = UUID.random.to_s
    property name : String
    property username : String
    property password : String

    def self.encrypt_password(password)
      Crypto::Bcrypt::Password.create(password, cost: 10).to_s
    end

    def password_instance
      Crypto::Bcrypt::Password.new(@password)
    end

    def initialize(@name, @username, password)
      @password = User.encrypt_password(password)
    end

    def password=(password)
      @password = User.encrypt_password(password)
    end

    def to_json(json : JSON::Builder)
      json.object do
        json.field "id", self.id
        json.field "name", self.name
      end
    end
  end
end
