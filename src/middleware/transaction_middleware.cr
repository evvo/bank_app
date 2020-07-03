module BankApp
  class TransactionMiddleware < Kemal::Handler
    # Matches GET /specials and GET /deals
    only ["/api/v1/transactions/:transaction_id"], "GET"
    only ["/api/v1/transactions/:transaction_id"], "POST"
    only ["/api/v1/transactions/:transaction_id"], "PUT"

    def has_access?(current_user_id, transaction)
      transaction.to_user == current_user_id ||
        transaction.from_user == current_user_id
    end

    def call(env)
      # continue on to next handler unless the request matches the only filter
      return call_next(env) unless only_match?(env)

      transaction_id = env.params.url["transaction_id"]
      current_user_id = BankApp::UserService.get_current_user_id(env)

      transaction = MemoryState.transactions_by_id[transaction_id]?

      # Add this part in case the transactions needs to be filtered by auth user
      if TOGGLE_AUTH_USER_TRANSACTIONS_ONLY
        if !transaction
          puts "Transaction Not found"
          Response.error(env, {:server => ["Not Found"]}, 404)
          return
        end

        if !has_access?(current_user_id, transaction)
          Response.error(env, {:server => ["Forbidden"]}, 403)
          return
        end
      end

      env.set "transaction", transaction

      call_next(env)
    end
  end
end
