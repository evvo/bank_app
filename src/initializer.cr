module BankApp
  class Initializer
    def self.init_users
      MemoryState.users = [
        User.new("John Marks", "john", "john"),
        User.new("Peter Johnson", "peter", "peter"),
        User.new("Mark Peterson", "mark", "mark"),
        User.new("Jane Peterson", "jane", "jane"),
      ]

      MemoryState.users.each do |user|
        MemoryState.add_user_to_index(user)
      end
    end

    def self.init_transactions
      MemoryState.transactions = [
        Transaction.new(29.99, Time.utc(2020, 2, 20), MemoryState.users[0].id, MemoryState.users[1].id, Status::PENDING),
        Transaction.new(25.99, Time.utc(2018, 10, 29), MemoryState.users[0].id, MemoryState.users[2].id, Status::PAID),
        Transaction.new(90.99, Time.utc(2019, 11, 29), MemoryState.users[2].id, MemoryState.users[3].id, Status::PAID),
        Transaction.new(90.99, Time.utc(2019, 11, 29), MemoryState.users[1].id, MemoryState.users[0].id, Status::PAID),
        Transaction.new(90.99, Time.utc(2019, 11, 29), MemoryState.users[2].id, MemoryState.users[1].id, Status::PAID),
      ]

      MemoryState.transactions.each do |transaction|
        MemoryState.add_transaction_to_index(transaction)
      end
    end

    def self.run
      self.init_users
      self.init_transactions
    end
  end
end
