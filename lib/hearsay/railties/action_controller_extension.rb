module Hearsay
  module Railties
    module ActionControllerExtension

      class Event

      end
      extend ActiveSupport::Concern

      included do
        puts "INCLUDED ACTION CONTROLLER"
        Hearsay.subscribe! /action_controller/i do |event|

          puts("event: #{event.name}")

        end
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  include Hearsay::Railties::ActionControllerExtension
end
