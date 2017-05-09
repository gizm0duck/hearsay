module Hearsay
  module Subscriber
    module ActiveRecord
      extend ActiveSupport::Concern

      @@events = Hash.new {|h,k| h[k]=[] }
      class_methods do

        def subscribe_to(klass, *args)
          args.each do |arg|
            key = "hearsay.active_record.#{klass}.#{arg}"
            @@events[key].push name
          end
        end
      end

      def self.subscribers_by_events
        @@events
      end
    end
  end
end
