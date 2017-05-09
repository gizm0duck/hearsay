module Hearsay
  module Subscriber
    module ActionController
      extend ActiveSupport::Concern

      @@subscribers = Hash.new {|h,k| h[k]=[] }
      @@events = Hash.new {|h,k| h[k]=[] }
      class_methods do

        def subscribe_to(*args)
          args.each do |arg|
            @@events[arg].push name
            @@subscribers[name.to_s].push arg
          end
        end
      end

      def self.events_by_subscribers
        @@subscribers
      end

      def self.subscribers_by_events
        @@events
      end
    end
  end
end
