module Hearsay
  module Railties
    module ActionCableExtension
      module Subscribe
        extend ActiveSupport::Concern

        included do
          Hearsay.subscribe! /perform_action.action_cable$/i do |event|

            payload = {
              channel_class: event.payload[:channel_class],
              action: event.payload[:action],
              start_time: event.time,
              end_time: event.end,
              data: event.payload[:data]
            }
            Hearsay::Publisher.push 'cable', payload
          end
        end
      end

      module Payload
        def perform_action(data)
          #add more data then pass it in
          if respond_to?(:hearsay_attributes)
            # request_data[:custom_attributes] = request.controller_instance.hearsay_attributes
            Thread.current[:hearsay_custom_attributes] = hearsay_attributes
          end
          super_data = data
          # super_data = data.merge({current_user: current_user.id, current_provider: current_provider.try(:id)})
          super super_data

        end
      end
    end
  end
end

ActiveSupport.on_load(:action_cable) do
  class ActionCable::Channel::Base
    include Hearsay::Railties::ActionCableExtension::Subscribe
    prepend Hearsay::Railties::ActionCableExtension::Payload
  end
end
