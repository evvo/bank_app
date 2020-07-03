module Errors
  error 500 do |env, exc|
    BankApp::Response.error(env, {"server" => ["Internal Server Error"]}, 500)
  end

  error 404 do |env, exc|
    BankApp::Response.error(env, {"server" => ["Not Found"]}, 404)
  end
end
