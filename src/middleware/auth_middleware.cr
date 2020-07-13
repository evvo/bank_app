module BankApp
  class AuthMiddleware < Kemal::Handler
    # Matches GET /specials and GET /deals
    exclude ["/api/v1/login"], "POST"
    exclude ["/*"], "OPTIONS"

    def get_token_from_request(env)
      if !env.request.headers["Authorization"]?
        raise "Authentication failed"
      end

      token_parts = env.request.headers["Authorization"].split("Bearer ")

      if token_parts.size < 2
        raise "Invalid Authorization Header"
      end

      return token_parts[1]
    end

    def call(env)
      return call_next(env) if exclude_match?(env)

      begin
        token = get_token_from_request(env)

        payload, header = JWT.decode(token, BankApp::SECRET_KEY, JWT::Algorithm::HS256)
        user_id = payload["user_id"].to_s

        user = MemoryState.users_by_id[user_id]?

        if !user
          raise "User not found"
        end

        env.set "current_user", MemoryState.users_by_id[user_id]
      rescue ex
        puts ex

        Response.error(env, {:auth => ["Session expired"]}, 403)
        return
      end

      call_next(env)
    end
  end
end
