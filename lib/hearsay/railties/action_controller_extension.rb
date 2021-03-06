module Hearsay
  module Railties
    module ActionControllerExtension
      extend ActiveSupport::Concern

      def append_info_to_payload(payload)
        super
        request_data = {
          server_ip: request.remote_ip,
          client_ip: request.ip,
        }
        response_data = {
          hearsay_header: response.header,
          status: response.status,
          hearsay_cookies: request.cookies
        }
        payload.merge! request_data
        payload[:response] = response_data
      end

      included do
        before_action :check_for_hearsay_custom_attributes

        def check_for_hearsay_custom_attributes
          if request.controller_instance.respond_to?(:hearsay_attributes)
            # request_data[:custom_attributes] = request.controller_instance.hearsay_attributes
            Thread.current[:hearsay_custom_attributes] = request.controller_instance.hearsay_attributes
          end
        end

        Hearsay.subscribe! /process_action.action_controller$/i do |event|


          hearsay_params = event.payload[:params].dup
          Hearsay.scrub_payload!(hearsay_params) {|k, v| !(String === v || Integer === v || Hash === v || Array === v) }

          payload = {
            headers: event.payload[:hearsay_header],
            controller: event.payload[:controller],
            cookies: event.payload[:hearsay_cookies],
            action: event.payload[:action],
            params: hearsay_params,
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
          }
          Hearsay::Publisher.push 'controller', payload

        end
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  if self == ActionController::Base
    include Hearsay::Railties::ActionControllerExtension
  end
end
