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
        }
        request_data[:custom_attributes] = request.controller_instance.hearsay_attributes if request.controller_instance.respond_to?(:hearsay_attributes)

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
            payload_out = {}
            headers_out = event.payload[:headers].instance_variable_get(:@req).env.reject{|k, v| !(String === v || Integer === v || Hash === v || Array === v) }
            if event.payload[:headers]["action_dispatch.cookies"]
              dispatch_cookies_out = event.payload[:headers]["action_dispatch.cookies"].reject{|k, v| !(String === v || Integer === v || Hash === v || Array === v) }
            else
              dispatch_cookies_out = {}
            end

            payload = {
              headers: headers_out.reject!{|k,v| !(k==k.upcase)},
              controller: event.payload[:controller],
              cookies: Hash[*dispatch_cookies_out.sort.flatten],
              action: event.payload[:action],
              params: event.payload[:params],
              format: event.payload[:format],
              method: event.payload[:method],
              path: event.payload[:path],
              status: event.payload[:status],
              view_runtime: event.payload[:view_runtime],
              db_runtime: event.payload[:db_runtime],
              server_ip: event.payload[:server_ip],
              client_ip: event.payload[:client_ip],
              uuid: event.payload[:uuid],
              response: event.payload[:response]
            }.merge(Hash(event.payload[:custom_attributes]))
            Hearsay::Publisher.push 'controller', payload
          end

        end
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  include Hearsay::Railties::ActionControllerExtension
end
