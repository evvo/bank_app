module Cors
  options "/*" do |env|
    cors_headers = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization"

    env.response.headers["Allow"] = "HEAD, GET, PUT, POST, DELETE, OPTIONS"
    env.response.headers["Access-Control-Allow-Headers"] = cors_headers

    halt env, status_code: 200
  end

  before_all do |env|
    cors_headers = "Content-Type, Accept, Origin, Authorization"

    env.response.headers["Access-Control-Allow-Origin"] = "*"
    env.response.headers["Access-Control-Allow-Methods"] = "GET, HEAD, POST, PUT"
    env.response.headers["Access-Control-Allow-Headers"] = cors_headers
    env.response.headers["Access-Control-Max-Age"] = "86400"
  end
end
