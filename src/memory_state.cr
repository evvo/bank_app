module BankApp
  class MemoryState
    class_property transactions = [] of Transaction
    class_property users : Array(User) = [] of User

    # Transaction indexes
    class_property transactions_by_user = Hash(String, Array(Transaction)).new
    class_property transactions_by_id = Hash(String, Transaction).new

    # User indexes
    class_property users_by_id = Hash(String, User).new
    class_property users_by_username = Hash(String, User).new

    def self.add_transaction_to_index(transaction)
      if !@@transactions_by_user[transaction.to_user]?
        @@transactions_by_user[transaction.to_user] = [] of Transaction
      end

      if !@@transactions_by_user[transaction.from_user]?
        @@transactions_by_user[transaction.from_user] = [] of Transaction
      end

      @@transactions_by_user[transaction.to_user] << transaction
      @@transactions_by_user[transaction.from_user] << transaction
      @@transactions_by_id[transaction.id] = transaction
    end

    def self.add_user_to_index(user)
      @@users_by_id[user.id] = user
      @@users_by_username[user.username] = user
    end

    def self.persist_transaction(transaction)
      @@transactions << transaction
      self.add_transaction_to_index(transaction)
    end
  end
end
