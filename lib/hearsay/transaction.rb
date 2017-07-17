
module Hearsay
  module Transaction
    def self.create(key = nil)
      Thread.current[:hearsay_transaction_id] = SecureRandom.hex(10)
    end

    def self.destroy
      Thread.current[:hearsay_transaction_id] = nil
      Thread.current[:hearsay_custom_attributes] = nil
    end

    def self.id=(id)
      Thread.current[:hearsay_transaction_id] = id
    end

    def self.id
      Thread.current[:hearsay_transaction_id]
    end
  end
end
