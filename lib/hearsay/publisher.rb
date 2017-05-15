require 'hearsay/subscriber/active_record'

module Hearsay
  class Publisher
    def self.push(type, payload)
      payload.merge!({
        hearsay_id: Hearsay::Transaction.id,
        hostname: Socket.gethostname,
        timestamp: DateTime.now.to_f,
        formattedTime: DateTime.now.strftime,
        pid: $$,
        hearsay_version: Hearsay::VERSION,
        thread: Thread.current.object_id
      })

      key = calculate_key(type, payload)
      ActiveSupport::Notifications.instrument key, payload
    end

    def self.calculate_key(type, payload)
      if type == 'model'
        return "hearsay.model.#{payload[:class_name]}.#{payload[:method_name]}"
      else
        return "hearsay.controller.#{payload[:controller]}.#{payload[:action]}"
      end
    end
  end
end
