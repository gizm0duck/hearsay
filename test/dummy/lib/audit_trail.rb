class AuditTrail
  include Hearsay::Subscriber::ActiveRecord

  subscribe_to :all, :update

  # Track all model changes
  def self.update(event)
    Log.json! event
  end
end
