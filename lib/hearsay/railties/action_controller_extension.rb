module Hearsay
  module Railties
    module ActionControllerExtension

      class Event

      end
      extend ActiveSupport::Concern

      def append_info_to_payload(payload)
        super
        request_data = {
          server_ip: request.remote_ip,
          uuid: 'ABC123',#request.uuid,
          client_ip: request.ip,
          hearsay_id: Hearsay::Transaction.id
        }
        response_data = {
          header: response.header,
          status: response.status,
        }

        payload.merge! request_data
        payload[:response] = response_data
      end

      included do
        puts "INCLUDED ACTION CONTROLLER"
        Hearsay.subscribe! /action_controller$/i do |event|
          if event.name == "process_action.action_controller"
            headers_out = event.payload[:headers].instance_variable_get(:@req).env.reject{|k, v| !(String === v || Integer === v || Hash === v || Array === v) }
            dispatch_cookies_out = event.payload[:headers]["action_dispatch.cookies"].reject{|k, v| !(String === v || Integer === v || Hash === v || Array === v) }
            headers_out.reject!{|k,v| !(k==k.upcase)}

            # hearsay.active_record.#{klass}.#{arg}
          end
          puts("hearsay transaction id: #{event.payload[:hearsay_id]}")

        end
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  include Hearsay::Railties::ActionControllerExtension
end
