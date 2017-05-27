class Hearsay::Event < ActiveSupport::Notifications::Event

  def initialize(*args)
    type = args[0].upcase

    args[4] = args[4].merge({
      uuid: SecureRandom.uuid,
      request_transaction_id: Hearsay::Transaction.id,
    }).merge(Hash(Thread.current[:hearsay_custom_attributes]))

    super args[0], args[1], args[2], args[3], args[4]
  end

end
