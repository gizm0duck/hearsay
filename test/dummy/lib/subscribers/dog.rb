class Subscribers::Dog
  include Hearsay::Subscriber::ActiveRecord

  #these are all of the types we can allow
  subscribe_to ::Dog, :update, :save


  def self.listen(event)
    puts "dog subscriber: #{event.name}"
  end

end
