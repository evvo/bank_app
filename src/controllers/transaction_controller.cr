module TransactionController
  get "/api/v1/transactions" do |env|
    current_user_id = BankApp::UserService.get_current_user_id(env)

    if BankApp::TOGGLE_AUTH_USER_TRANSACTIONS_ONLY
      transactions = BankApp::MemoryState.transactions_by_user[current_user_id]
    else
      transactions = BankApp::MemoryState.transactions
    end

    transactions = BankApp::QueryParser.filter_results(transactions, env.params.query)
    sorted_transactions = BankApp::QueryParser.sort_results(transactions, env.params.query)

    BankApp::Response.success(env, sorted_transactions)
  end

  get "/api/v1/transactions/:transaction_id" do |env|
    transaction_id = env.params.url["transaction_id"]
    current_user_id = BankApp::UserService.get_current_user_id(env)

    BankApp::Response.success(env, env.get("transaction"))
  end

  put "/api/v1/transactions/:transaction_id" do |env|
    transaction_id = env.params.url["transaction_id"]
    current_user_id = BankApp::UserService.get_current_user_id(env)

    transaction = env.get("transaction").as(BankApp::Transaction)
    temp_transaction = transaction.dup

    status = env.params.json["status"].as(Int64)

    temp_transaction.status = BankApp::Status.new(status)

    if !temp_transaction.valid?
      BankApp::Response.error(env, temp_transaction.invalid_attributes)
      next
    end

    transaction.status = BankApp::Status.new(status)
    BankApp::Response.success(env, transaction)
  end

  post "/api/v1/transactions" do |env|
    current_user_id = BankApp::UserService.get_current_user_id(env)
    begin
      from_user = env.params.json["from_user"].as(String)
      to_user = env.params.json["to_user"].as(String)
      amount = env.params.json["amount"].as(String).to_f64
    rescue
      BankApp::Response.error(env, {:transaction => ["Invalid parameters"]}, 422)
      next
    end

    transaction = BankApp::Transaction.new(
      amount,
      Time.utc,
      from_user,
      to_user,
      BankApp::Status::PENDING
    )

    if !transaction.valid?
      BankApp::Response.error(env, transaction.invalid_attributes, 422)
      next
    end

    BankApp::MemoryState.persist_transaction(transaction)
    BankApp::Response.success(env, transaction)
  end
end
