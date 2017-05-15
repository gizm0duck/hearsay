class Hearsay::Event < ActiveSupport::Notifications::Event
  attr_reader :type

  def initialize(*args)
    type = args[0].upcase

    args[4] = args[4].merge({
      hearsay_id: Hearsay::Transaction.id
    })
    
    super args[0],args[1],args[2],args[3],args[4]
  end


  # something like this so we can augment the payload based on event types (ActionController, ActiveRecord, etc)
  def type=(type)
    @type = type
  end
end
