class Subscribers::Cat
  include Hearsay::Subscriber::ActiveRecord

  #these are all of the types we can allow
  subscribe_to ::Cat, :update

  def self.listen(event)
    puts "cat subscriber: #{event.name}, #{event.payload}"
  end

end
