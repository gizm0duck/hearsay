class Subscribers::Cat
  include Hearsay::Subscriber::ActiveRecord

  #these are all of the types we can allow
  subscribe_to ::Cat, :update

  def self.update(event)
    puts "cat subscriber: #{event.name}, #{event.payload}"
  end

end
