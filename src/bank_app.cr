require "uuid"
require "crypto/bcrypt/password"
require "jwt"
require "kemal"
require "validations"
require "./**"

module BankApp
  VERSION = "0.1.0"
  # Secret key for JWT
  SECRET_KEY = "SecretKey"
  # JWT expiration timeout
  TOKEN_EXPIRATION_TIMEOUT           = (5 * 60)
  TOGGLE_AUTH_USER_TRANSACTIONS_ONLY = false
  # Used for testing purposes
  # example - 300ms: TOGGLE_ARTFICIAL_DELAY = 0.3
  TOGGLE_ARTFICIAL_DELAY = 0

  Kemal.config.env = "production"
  Kemal.config.powered_by_header = false

  before_all "/api/v1/*" do |env|
    if TOGGLE_ARTFICIAL_DELAY
      sleep TOGGLE_ARTFICIAL_DELAY
    end

    env.response.content_type = "application/json"
  end

  add_handler AuthMiddleware.new
  add_handler TransactionMiddleware.new

  add_context_storage_type(BankApp::User)
  add_context_storage_type(BankApp::Transaction)

  include Cors
  include Errors

  include AuthController
  include TransactionController
  include UserController

  # Seed Memory Storage
  Initializer.run

  Kemal.run
end
