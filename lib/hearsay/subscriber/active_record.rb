module Hearsay
  module Subscriber
    module ActiveRecord
      extend ActiveSupport::Concern
      class_methods do

        def subscribe_to(klass, *args)
          args.each do |arg|
            key = klass == :all ? /hearsay\.active_record\.\w+\.#{arg}/ : "hearsay.active_record.#{klass}.#{arg}"
            Hearsay.subscribe! key do |event|
              method_name = event.name.split('.').last
              name.constantize.send(method_name, event) if name.constantize.respond_to? method_name
            end
          end
        end
      end
    end
  end
end
