module BankApp
  class Transaction
    include JSON::Serializable
    include Validations
    include CustomValidations

    property status : Status
    property amount : Int64
    property date : Time
    getter from_user, to_user
    getter id : String = UUID.random.to_s

    def initialize(amount : Float64, @date : Time, @from_user : String, @to_user : String, @status)
      @amount = (amount * 100).to_i64
    end

    validate status, in: {Status::PENDING, Status::PAID}, presence: true
    validate amount, gte: 1, presence: true
    validate date, presence: true
    validate to_user, existing_user: true
    validate from_user, existing_user: true

    def to_json(json : JSON::Builder)
      json.object do
        json.field "id", self.id
        json.field "amount", self.amount / 100
        json.field "date", self.date
        json.field "status", self.status
        json.field "from_user", MemoryState.users_by_id[@from_user]
        json.field "to_user", MemoryState.users_by_id[@to_user]
      end
    end
  end
end
