module Cors
  options "/*" do |env|
    env.response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
    env.response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Token"

    halt env, status_code: 200
  end

  before_all do |env|
    env.response.headers["Access-Control-Allow-Origin"] = "*"
    env.response.headers["Access-Control-Allow-Methods"] = "GET, HEAD, POST, PUT"
    env.response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept, Origin, Authorization, Token"
    env.response.headers["Access-Control-Max-Age"] = "86400"
  end
end