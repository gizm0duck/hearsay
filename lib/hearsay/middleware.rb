require 'hearsay/transaction'

module Hearsay
  class Middleware
    KEY_HEADER = 'HEARSAY_KEY'
    ID_HEADER = 'HEARSAY_ID'

    def initialize(app, options = {})
      @app = app
      @key = "WEB"
    end

    def call(env)
      key = env.fetch("HTTP_#{KEY_HEADER}", @key)
      Hearsay::Transaction.create key
      # env.store("HTTP_#{ID_HEADER}", Hearsay::Transaction.id)
      @app.call(env)
    ensure
      Hearsay::Transaction.destroy
    end
  end
end
