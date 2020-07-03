module CustomValidations
  include Validations

  rule :existing_user do |attr, value, rule|
    invalidate(attr, "User must exists") unless BankApp::MemoryState.users_by_id[value]?
  end
end
