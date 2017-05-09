# Hearsay
Pub-sub library with active_record and action_controller hooks

## Usage

Decouple your models with event listeners


This is an example where we subscribe to all update calls for all ActiveRecord models
```
class UserSideEffects
  include Hearsay::Subscriber::ActiveRecord

  subscribe_to User, :create

  # Do stuff after user creation
  def self.create(event)
    UserMailer.welcome(event.payload[:id]).deliver_later
    AnalyticsService.register event
  end
end
```

This is an example where we subscribe to all update calls for all ActiveRecord models
```
class AuditTrail
  include Hearsay::Subscriber::ActiveRecord

  subscribe_to :all, :update

  # Track all model changes
  def self.update(event)
    Log.json! event
  end
end
```

OUTPUT
```
Cat.last.update_attributes name: "Stephen"

{"name":"hearsay.active_record.Cat.update","payload":{"attributes":{"id":47,"name":"Stephen","type":"Cat","age":null,"created_at":"2017-05-09T08:50:14.158Z","updated_at":"2017-05-09T08:57:41.168Z"},"changes":{"name":["ste","Stephen"],"updated_at":["2017-05-09T08:57:00.959Z","2017-05-09T08:57:41.168Z"]}},"time":"2017-05-09T01:57:41.170-07:00","transaction_id":"b78827efc356421a77b3","end":"2017-05-09T01:57:41.170-07:00","children":[],"duration":null}
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
