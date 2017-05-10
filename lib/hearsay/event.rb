class Hearsay::Event < ActiveSupport::Notifications::Event
  attr_reader :type

  def initialize(*args)
    type = args[0].upcase
    super
  end


  # something like this so we can augment the payload based on event types (ActionController, ActiveRecord, etc)
  def type=(type)
    @type = type
  end
end
