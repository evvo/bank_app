module BankApp
  class Response
    def self.error(env, response, status_code = 400)
      env.response.content_type = "application/json"
      env.response.status_code = status_code
      env.response.headers["Access-Control-Allow-Origin"] = "*"

      json_response = {"errors" => response}.to_json
      env.response.print json_response
      env.response.close
    end

    def self.success(env, response, status_code = 200)
      env.response.content_type = "application/json"
      env.response.status_code = status_code
      env.response.headers["Access-Control-Allow-Origin"] = "*"

      json_response = {"success" => true, "data" => response}.to_json
      env.response.print json_response
      env.response.close
    end
  end
end
