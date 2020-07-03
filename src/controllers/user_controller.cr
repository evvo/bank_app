module UserController
  get "/api/v1/users" do |env|
    name = env.params.query["name"]?

    if !name
      BankApp::Response.success(env, BankApp::MemoryState.users.first(2))
      next
    end

    name = name.lstrip
    name = name.rstrip

    if name.size == 0
      BankApp::Response.success(env, BankApp::MemoryState.users.first(2))
      next
    end

    BankApp::Response.success(env, BankApp::MemoryState.users.select { |user|
      user.name.includes?(name.not_nil!)
    })
  end
end
