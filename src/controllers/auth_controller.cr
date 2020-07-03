module AuthController
  post "/api/v1/login" do |env|
    username = env.params.json["username"].as(String)
    password = env.params.json["password"].as(String)

    user = BankApp::MemoryState.users_by_username[username]?

    if !user
      puts "Incorrect user"
      BankApp::Response.error(env, {"user" => ["Incorrect username or password"]}, 422)
      next
    end

    if !user.password_instance.verify(password)
      puts "Incorrect password"
      BankApp::Response.error(env, {"user" => ["Incorrect username or password"]}, 422)
      next
    end

    payload = {"user_id" => user.id, "exp" => BankApp::TOKEN_EXPIRATION_TIMEOUT}
    token = JWT.encode(payload, BankApp::SECRET_KEY, JWT::Algorithm::HS256)

    BankApp::Response.success(env, {"token" => token})
  end
end